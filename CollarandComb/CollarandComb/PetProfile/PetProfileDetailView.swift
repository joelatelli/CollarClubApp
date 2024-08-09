//
//  PetProfileDetailView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import Shimmer
import SwiftUI

@MainActor
struct PetProfileDetailView: View {
	@Environment(\.openURL) private var openURL
	@Environment(\.redactionReasons) private var reasons
	@Environment(\.openWindow) private var openWindow

	@Environment(StreamWatcher.self) private var watcher
	@Environment(CurrentAccount.self) private var currentAccount
	@Environment(CurrentInstance.self) private var currentInstance
	@Environment(UserPreferences.self) private var preferences
	@Environment(Theme.self) private var theme
	@Environment(Client.self) private var client
	@Environment(RouterPath.self) private var routerPath

	@State private var viewModel: PetProfileDetailViewModel
	@State private var isCurrentUser: Bool = false
	@State private var showBlockConfirmation: Bool = false
	@State private var showDeleteConfirmation: Bool = false

	@State private var isEditingAccount: Bool = false
	@State private var isEditingFilters: Bool = false
	@State private var isEditingRelationshipNote: Bool = false

	@State private var displayTitle: Bool = false

	/// When coming from a URL like a mention tap in a status.
	init(profileId: String) {
		_viewModel = .init(initialValue: .init(profileId: profileId))
	}

	/// When the profile is already fetched by the parent caller.
	init(profile: PetProfile) {
		_viewModel = .init(initialValue: .init(profile: profile))
	}

	public var body: some View {
		ScrollViewReader { proxy in
			List {
				ScrollToView()
					.onAppear { displayTitle = false }
					.onDisappear { displayTitle = true }
				makeHeaderView(proxy: proxy)
					.applyAccountDetailsRowStyle(theme: theme)
					.padding(.bottom, -20)

				questionsView
//				familiarFollowers
//					.applyAccountDetailsRowStyle(theme: theme)
//				featuredTagsView
//					.applyAccountDetailsRowStyle(theme: theme)


//				StatusesListView(fetcher: viewModel,
//								 client: client,
//								 routerPath: routerPath)
			}
			.environment(\.defaultMinListRowHeight, 1)
			.listStyle(.plain)
			.scrollContentBackground(.hidden)
			.background(theme.primaryBackgroundColor)
		}
		.onAppear {
			guard reasons != .placeholder else { return }
//			isCurrentUser = currentAccount.account?.id == viewModel.accountId
			viewModel.isCurrentUser = isCurrentUser
			viewModel.client = client

			// Avoid capturing non-Sendable `self` just to access the view model.
			let viewModel = viewModel
			Task {
				await withTaskGroup(of: Void.self) { group in
					group.addTask { await viewModel.fetchAccount() }
					group.addTask {
//						if await viewModel.statuses.isEmpty {
//							await viewModel.fetchNewestStatuses(pullToRefresh: false)
//						}
					}
					if !viewModel.isCurrentUser {
						group.addTask { await viewModel.fetchFamilliarFollowers() }
					}
				}
			}
		}
		.refreshable {
			Task {
				SoundEffectManager.shared.playSound(.pull)
				HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
				await viewModel.fetchAccount()
				await viewModel.fetchNewestStatuses(pullToRefresh: true)
				HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
				SoundEffectManager.shared.playSound(.refresh)
			}
		}
		.onChange(of: watcher.latestEvent?.id) {
//			if let latestEvent = watcher.latestEvent,
//			   viewModel.accountId == currentAccount.account?.id
//			{
//				viewModel.handleEvent(event: latestEvent, currentAccount: currentAccount)
//			}
		}
		.onChange(of: isEditingAccount) { _, newValue in
			if !newValue {
				Task {
					await viewModel.fetchAccount()
					await preferences.refreshServerPreferences()
				}
			}
		}
//		.sheet(isPresented: $isEditingAccount, content: {
//			EditPetProfileView()
//		})
		.edgesIgnoringSafeArea(.top)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			toolbarContent
		}
	}

	@ViewBuilder
	private func makeHeaderView(proxy: ScrollViewProxy?) -> some View {
		switch viewModel.profileState {
		case .loading:
			PetProfileDetailHeaderView(viewModel: viewModel,
									   profile: PetProfile.placeholder())
			.redacted(reason: .placeholder)
			.allowsHitTesting(false)
		case let .data(profile):
			PetProfileDetailHeaderView(viewModel: viewModel,
									   profile: profile)
		case let .error(error):
			Text("Error: \(error.localizedDescription)")
		}
	}

	@ViewBuilder
	private var featuredTagsView: some View {
		Text("Featured")
	}

	@ViewBuilder
	private var familiarFollowers: some View {
		if !viewModel.familiarFollowers.isEmpty {
			VStack(alignment: .leading, spacing: 2) {
				Text("account.detail.familiar-followers")
					.font(.scaledHeadline)
					.padding(.leading, .layoutPadding)
					.accessibilityAddTraits(.isHeader)
				ScrollView(.horizontal, showsIndicators: false) {
					LazyHStack(spacing: 0) {
						ForEach(viewModel.familiarFollowers) { account in
							Button {
//								routerPath.navigate(to: .accountDetailWithAccount(user: account))
							} label: {
								AvatarView(account.avatar, config: .badge)
									.padding(.leading, -4)
									.accessibilityLabel(account.safeDisplayName)

							}
							.accessibilityAddTraits(.isImage)
							.buttonStyle(.plain)
						}
					}
					.padding(.leading, .layoutPadding + 4)
				}
			}
			.padding(.top, 2)
			.padding(.bottom, 12)
		}
	}

	@ViewBuilder
	private var questionsView: some View {
		VStack(alignment: .leading) {

			Text("Age of pet".uppercased())
				.font(.system(size: 16, weight: .bold))
				.padding(.top, 15)

//			HStack { ModTextView(text: "Age of pet".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
//				.padding(.top, 15)

			Text(viewModel.profile!.age ?? "n/a")
				.font(.system(size: 18, weight: .regular))
				.padding(.top, 8)
				.foregroundColor(theme.tintColor)

//			HStack { ModTextView(text: viewModel.profile!.age ?? "n/a", type: .body_1).foregroundColor(Color.text_primary_color); Spacer() }
//				.padding(.top, 8)

			Text("Breed of your dog...".uppercased())
				.font(.system(size: 16, weight: .bold))
				.padding(.top, 15)

//			HStack { ModTextView(text: "Breed of your dog...".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
//				.padding(.top, 15)

			Text(viewModel.profile!.breed ?? "n/a")
				.font(.system(size: 18, weight: .regular))
				.padding(.top, 8)
				.foregroundColor(theme.tintColor)

//			HStack { ModTextView(text: viewModel.profile!.breed ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
//				.padding(.top, 8)

			Text("How much does your dog weigh?".uppercased())
				.font(.system(size: 16, weight: .bold))
				.padding(.top, 15)

//			HStack { ModTextView(text: "How much does your dog weigh?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
//				.padding(.top, 15)

			Text(viewModel.profile!.weight ?? "n/a")
				.font(.system(size: 18, weight: .regular))
				.padding(.top, 8)
				.foregroundColor(theme.tintColor)

//			HStack { ModTextView(text: viewModel.profile!.weight ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
//				.padding(.top, 8)

			questionsView2
		}
		.padding(10)
		.listRowBackground(theme.primaryBackgroundColor)
		.listRowSeparator(.hidden)
		.listRowInsets(EdgeInsets())
	}

	@ViewBuilder
	private var questionsView2: some View {
		VStack(alignment: .leading) {

			Text("Whats the temperment of your dog?".uppercased())
				.font(.system(size: 16, weight: .bold))
				.padding(.top, 15)

//			HStack { ModTextView(text: "Whats the temperment of your dog?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
//				.padding(.top, 15)

			Text(viewModel.profile!.temperment ?? "n/a")
				.font(.system(size: 18, weight: .regular))
				.padding(.top, 8)
				.foregroundColor(theme.tintColor)

//			HStack { ModTextView(text: viewModel.profile!.temperment ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
//				.padding(.top, 8)

			Text("Does your dog have any special needs?".uppercased())
				.font(.system(size: 16, weight: .bold))
				.padding(.top, 15)

//			HStack { ModTextView(text: "Does your dog have any special needs?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
//				.padding(.top, 15)

			Text(viewModel.profile!.specialNeeds ?? "n/a")
				.font(.system(size: 18, weight: .regular))
				.padding(.top, 8)
				.foregroundColor(theme.tintColor)

//			HStack { ModTextView(text: viewModel.profile!.specialNeeds ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
//				.padding(.top, 8)

			Text("Is your dog vaccinated (and When)?".uppercased())
				.font(.system(size: 16, weight: .bold))
				.padding(.top, 15)

//			HStack { ModTextView(text: "Is your dog vaccinated (and When)?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
//				.padding(.top, 15)

			Text(viewModel.profile!.lastVaccinated ?? "n/a")
				.font(.system(size: 18, weight: .regular))
				.padding(.top, 8)
				.foregroundColor(theme.tintColor)

//			HStack { ModTextView(text: viewModel.profile!.lastVaccinated ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
//				.padding(.top, 8)
		}
		.listRowBackground(theme.primaryBackgroundColor)
		.listRowSeparator(.hidden)
		.listRowInsets(EdgeInsets())
	}

	@ViewBuilder
	private var pinnedPostsView: some View {
		EmptyView()
//		if !viewModel.pinned.isEmpty {
//			Label("account.post.pinned", systemImage: "pin.fill")
//				.accessibilityAddTraits(.isHeader)
//				.font(.scaledFootnote)
//				.foregroundStyle(.secondary)
//				.fontWeight(.semibold)
//				.listRowInsets(.init(top: 0,
//									 leading: 12,
//									 bottom: 0,
//									 trailing: .layoutPadding))
//				.listRowSeparator(.hidden)
//#if !os(visionOS)
//				.listRowBackground(theme.primaryBackgroundColor)
//#endif
////			ForEach(viewModel.pinned) { status in
////				StatusRowView(viewModel: .init(status: status, client: client, routerPath: routerPath))
////			}
//			Rectangle()
//				.fill(theme.secondaryBackgroundColor)
//				.frame(height: 12)
//				.listRowInsets(.init())
//				.listRowSeparator(.hidden)
//				.accessibilityHidden(true)
//		}
	}

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			if let profile = viewModel.profile {
				VStack {
					Text(profile.name ?? "").font(.headline)
				}
			}
		}
		ToolbarItemGroup(placement: .navigationBarTrailing) {
			Button {
				if let account = viewModel.profile {
					showDeleteConfirmation.toggle()
				}
			} label: {
				Image(systemName: "trash")
			}
			.confirmationDialog("Delete Profile", isPresented: $showDeleteConfirmation) {
				if let account = viewModel.profile {
					Button("Delete \(account.name ?? "") Profile", role: .destructive) {
						Task {
							do {
//								viewModel.deleteProfile()
								await viewModel.delete()
							} catch {
								print("Error while deleting: \(error.localizedDescription)")
							}
						}
					}
				}
			} message: {
				Text("Confirm Delete")
			}

			Button {
				if let account = viewModel.profile {
#if targetEnvironment(macCatalyst) || os(visionOS)
					openWindow(value: WindowDestinationEditor.mentionStatusEditor(account: account, visibility: preferences.postVisibility))
#else
					routerPath.presentedSheet = .editProfile(profile: account)
#endif
				}
			} label: {
				Text("Edit")
//				Image(systemName: "arrowshape.turn.up.left")
			}
		}
	}
}

//extension View {
//	func applyAccountDetailsRowStyle(theme: Theme) -> some View {
//		listRowInsets(.init())
//			.listRowSeparator(.hidden)
//#if !os(visionOS)
//			.listRowBackground(theme.primaryBackgroundColor)
//#endif
//	}
//}

//struct AccountDetailView_Previews: PreviewProvider {
//	static var previews: some View {
//		PetProfileDetailView(account: .placeholder(), scrollToTopSignal: .constant(0))
//	}
//}

