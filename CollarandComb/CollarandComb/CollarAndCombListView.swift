//
//  CollarAndCombListView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import Shimmer
import SwiftUI

@MainActor
public struct CollarAndCombListView: View {
	@Environment(Theme.self) private var theme
	@Environment(Client.self) private var client
	@Environment(CurrentAccount.self) private var currentAccount
	@Environment(CurrentUser.self) private var currentUser
	@Environment(RouterPath.self) private var routerPath

	@State private var viewModel: CollarAndCombListViewModel
	@State private var didAppear: Bool = false

	let websites: [(URL, String, URL)] = [
		(URL(string: "https://collarandcomb.dog/training/")!, "Training", URL(string: "https://collarandcomb.dog/wp-content/uploads/2023/03/Hounds-of-Huckletree-Header.png")!),
		(URL(string: "https://collarandcomb.dog/daycare/")!, "Daycare", URL(string: "https://collarandcomb.dog/wp-content/uploads/2023/07/Daycare-Green-2-scaled.jpg")!),
		(URL(string: "https://collarandcomb.dog/about-us/")!, "About Us", URL(string: "https://collarandcomb.dog/wp-content/uploads/2023/03/IMG_9418-scaled.jpg")!),
		(URL(string: "https://collarandcomb.dog/faq/")!, "FAQ", URL(string: "https://collarandcomb.dog/wp-content/uploads/2023/03/IMG_9420-scaled.jpg")!),
		(URL(string: "https://collarandcomb.dog/pricing-and-services/")!, "Pricing and Services", URL(string: "https://collarandcomb.dog/wp-content/uploads/2023/04/menu-board-edits-updatex-scaled.jpg")!),
		// Add more websites and button titles here
	]

	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]

	public init(mode: CollarAndCombListListMode) {
		_viewModel = .init(initialValue: .init(mode: mode))
	}

	public var body: some View {
		listView
#if !os(visionOS)
			.scrollContentBackground(.hidden)
			.background(theme.primaryBackgroundColor)
#endif
			.listStyle(.plain)
			.toolbar {
				ToolbarItem(placement: .principal) {
					VStack {
						Text(viewModel.mode.title)
							.font(.headline)
						if let count = viewModel.totalCount {
							Text(String(count))
								.font(.footnote)
								.foregroundStyle(.secondary)
						}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					addProfileButton
				}
			}
			.navigationTitle(viewModel.mode.title)
			.navigationBarTitleDisplayMode(.inline)
			.task {
				viewModel.client = client
				viewModel.accountId = currentUser.user?.id?.uuidString
				guard !didAppear else { return }
				didAppear = true
				await viewModel.fetch()
			}
			.refreshable {
				HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
				await viewModel.fetch()
				HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
			}

	}

	@ViewBuilder
	private var listView: some View {
//		if currentAccount.account?.id == viewModel.accountId {
//			searchableList
//		} else {
			standardList
//		}
	}

	private var searchableList: some View {
		List {
			listContent
		}
		.searchable(text: $viewModel.searchQuery,
					placement: .navigationBarDrawer(displayMode: .always))
		.task(id: viewModel.searchQuery) {
			if !viewModel.searchQuery.isEmpty {
				await viewModel.search()
			}
		}
		.onChange(of: viewModel.searchQuery) { _, newValue in
			if newValue.isEmpty {
				Task {
					await viewModel.fetch()
				}
			}
		}
	}

	private var standardList: some View {
		List {
			Text("My Pet Profiles")
				.font(.system(size: 28))
				.lineLimit(2)
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			listContent

			Section {

				Text("Learn more about Collar and Comb")
					.font(.system(size: 28))
					.lineLimit(2)
					.listRowBackground(theme.primaryBackgroundColor)
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets())
					.padding(.top, 30)
					.padding(.bottom, 10)
					.padding(.horizontal, 10)
					.multilineTextAlignment(.leading)

				ForEach(websites, id: \.0) { website in
					WebsiteButton(websiteURL: website.0, buttonText: website.1, imageURL: website.2)
				}
//				.padding(.bottom, 10)

//				WebsiteButton(websiteURL: URL(string: "https://collarandcomb.dog/pricing-and-services/")!, buttonText: "Pricing and Services", imageURL: URL(string: "https://collarandcomb.dog/wp-content/uploads/2023/04/menu-board-edits-updatex-scaled.jpg")!)


				Spacer()
					.frame(height: 50)
			}
			.listRowBackground(theme.primaryBackgroundColor)
			.listRowSeparator(.hidden)
			.listRowInsets(EdgeInsets())

//			serviceListContent
		}
	}

	@ViewBuilder
	private var listContent: some View {
		switch viewModel.state {
		case .loading:
			ForEach(PetProfile.placeholders()) { _ in
				PetProfileListRow(viewModel: .init(profile: .placeholder(), relationShip: nil))
					.redacted(reason: .placeholder)
					.allowsHitTesting(false)
					.shimmering()
					.listRowBackground(theme.primaryBackgroundColor)
			}
		case let .display(profiles, nextPageState):
			Section {
				ForEach(profiles) { profile in
					PetProfileListRow(viewModel: .init(profile: profile, relationShip: nil))
						.listRowBackground(theme.primaryBackgroundColor)
						.id(profile.id!.uuidString)
				}
			}

			switch nextPageState {
			case .hasNextPage:
				loadingRow
#if !os(visionOS)
					.listRowBackground(theme.primaryBackgroundColor)
#endif
					.onAppear {
						Task {
							await viewModel.fetchNextPage()
						}
					}

			case .loadingNextPage:
				loadingRow
#if !os(visionOS)
					.listRowBackground(theme.primaryBackgroundColor)
#endif
			case .none:

				HStack(alignment: .top) {

					ZStack {
					   Circle()
						   .fill(theme.tintColor) // Change the color as desired
						   .frame(width: 45, height: 45)

						Text(String("P"))
							 .font(.system(size: 18))
							 .lineLimit(2)
							 .foregroundColor(Color.text_primary_color)
							 .multilineTextAlignment(.center)
//						Image("footprint")
//							.resizable()
//							.scaledToFit()
//							.frame(height: 25)
//							.background(Color.primary_color)
//							.padding(.trailing, 4)
					}
					.padding(.trailing, 6)

					VStack(alignment: .leading) {
						Text("Add profile")
							.font(.system(size: 18, weight: .bold))
							 .lineLimit(2)
							 .foregroundColor(theme.tintColor)
							 .multilineTextAlignment(.center)

						Text("Add A New Profile For My Pet")
							 .font(.system(size: 16))
							 .lineLimit(2)
							 .foregroundColor(Color.text_primary_color)
							 .multilineTextAlignment(.center)
					}

					Spacer()

					Image(systemName: "plus")
						.font(Font.system(size: 24, weight: .regular))
						.foregroundColor(theme.tintColor)

				}
				.padding(.bottom, 8)
				.background {
					Color.clear
						.contentShape(Rectangle())
						.onTapGesture {
							routerPath.presentedSheet = .newProfile
						}
				}
				.listRowBackground(theme.primaryBackgroundColor)
				.alignmentGuide(.listRowSeparatorLeading) { _ in
					-100
				}

			}

		case let .error(error):
			Text(error.localizedDescription)
#if !os(visionOS)
				.listRowBackground(theme.primaryBackgroundColor)
#endif
		}
	}

	@ViewBuilder
	private var serviceListContent: some View {
		switch viewModel.state {
		case .loading:
			ForEach(PetProfile.placeholders()) { _ in
				PetProfileListRow(viewModel: .init(profile: .placeholder(), relationShip: nil))
					.redacted(reason: .placeholder)
					.allowsHitTesting(false)
					.shimmering()
					.listRowBackground(theme.primaryBackgroundColor)
			}
		case let .display(profiles, nextPageState):
			Section {
				HStack {

					Text("Learn more about Collar and Comb")
						.font(.system(size: 22))
						.lineLimit(2)

					Spacer()

				}
				.padding(.top, 30)
				.padding(.bottom, 10)
				.listRowBackground(theme.primaryBackgroundColor)

//				LazyVGrid(columns: columns, spacing: 20) {
//					ForEach(websites, id: \.0) { website in
//						WebsiteButton(websiteURL: website.0, buttonText: website.1, imageURL: website.2)
//					}
//				}
//				.padding(.bottom, 10)

				ForEach(websites, id: \.0) { website in
					WebsiteButton(websiteURL: website.0, buttonText: website.1, imageURL: website.2)
				}

				WebsiteButton(websiteURL: URL(string: "https://collarandcomb.dog/pricing-and-services/")!, buttonText: "Pricing and Services", imageURL: URL(string: "https://collarandcomb.dog/wp-content/uploads/2023/04/menu-board-edits-updatex-scaled.jpg")!)


				Spacer()
					.frame(height: 50)
			}

			switch nextPageState {
			case .hasNextPage:
				loadingRow
#if !os(visionOS)
					.listRowBackground(theme.primaryBackgroundColor)
#endif
					.onAppear {
						Task {
							await viewModel.fetchNextPage()
						}
					}

			case .loadingNextPage:
				loadingRow
#if !os(visionOS)
					.listRowBackground(theme.primaryBackgroundColor)
#endif
			case .none:
				EmptyView()
			}

		case let .error(error):
			Text(error.localizedDescription)
#if !os(visionOS)
				.listRowBackground(theme.primaryBackgroundColor)
#endif
		}
	}

	private var loadingRow: some View {
		HStack {
			Spacer()
			ProgressView()
			Spacer()
		}
	}

	private var addProfileButton: some View {
	  Button {
		  routerPath.presentedSheet = .newProfile
	  } label: {
		Image(systemName: "plus")
	  }
	  .accessibilityLabel("Add pet profile")
	}
}
