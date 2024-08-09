//
//  AccountDetailView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/3/24.
//

import EmojiText
import Network
import Shimmer
import SwiftUI

@MainActor
struct AccountDetailView: View {
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
	@Environment(CurrentUser.self) private var currentUser
	@Environment(CartManager.self) private var cartManager

	@State private var viewModel: AccountDetailViewModel
	@State private var isCurrentUser: Bool = false
	@State private var showBlockConfirmation: Bool = false

	@State private var isEditingAccount: Bool = false
	@State private var isEditingFilters: Bool = false
	@State private var isEditingRelationshipNote: Bool = false

	let context = CIContext()
	let filter = CIFilter.qrCodeGenerator()

	@State private var showingSheet = false
	@State private var showSavedView = false
	@State private var showHistoryView = false
	@State private var isShowingScanner = false

	@State private var showingOptions = false

	@State private var name = "Anonymous"
	@State private var emailAddress = "you@yoursite.com"
	@State private var initials = "C&F"

	@State private var displayTitle: Bool = false

	@Binding var scrollToTopSignal: Int

	/// When coming from a URL like a mention tap in a status.
	public init(accountId: String, scrollToTopSignal: Binding<Int>) {
		_viewModel = .init(initialValue: .init(accountId: accountId))
		_scrollToTopSignal = scrollToTopSignal
	}

	/// When the account is already fetched by the parent caller.
	public init(user: User, scrollToTopSignal: Binding<Int>) {
		_viewModel = .init(initialValue: .init(user: user))
		_scrollToTopSignal = scrollToTopSignal
	}

	public var body: some View {
		ScrollViewReader { proxy in
			List {
				makeHeaderView(proxy: proxy)
					.applyAccountDetailsRowStyle(theme: theme)
					.padding(10)

				buttonsView
					.padding(.horizontal, 10)

			}
			.environment(\.defaultMinListRowHeight, 1)
			.listStyle(.plain)
#if !os(visionOS)
			.scrollContentBackground(.hidden)
			.background(theme.primaryBackgroundColor)
#endif
			.onChange(of: scrollToTopSignal) {
				withAnimation {
					proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
				}
			}
		}
		.onAppear {
			guard reasons != .placeholder else { return }
			isCurrentUser = currentAccount.user?.id?.uuidString == viewModel.accountId
			viewModel.isCurrentUser = isCurrentUser
			viewModel.client = client

			// Avoid capturing non-Sendable `self` just to access the view model.
			let viewModel = viewModel
			Task {
				await withTaskGroup(of: Void.self) { group in
					group.addTask { await viewModel.fetchAccount() }
//					group.addTask {
//						if await viewModel.statuses.isEmpty {
//							await viewModel.fetchNewestStatuses(pullToRefresh: false)
//						}
//					}
//					if !viewModel.isCurrentUser {
//						group.addTask { await viewModel.fetchFamilliarFollowers() }
//					}
				}
			}
		}
		.refreshable {
			Task {
				HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
				await viewModel.fetchAccount()
//				await viewModel.fetchNewestStatuses(pullToRefresh: true)
				HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
			}
		}
		.onChange(of: watcher.latestEvent?.id) {
			if let latestEvent = watcher.latestEvent,
			   viewModel.accountId == currentAccount.account?.id
			{
				viewModel.handleEvent(event: latestEvent, currentAccount: currentAccount)
			}
		}
		.onChange(of: isEditingAccount) { _, newValue in
			if !newValue {
				Task {
					await viewModel.fetchAccount()
					await preferences.refreshServerPreferences()
				}
			}
		}
		.sheet(isPresented: $isEditingAccount, content: {
			EditAccountView()
		})
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			toolbarContent
		}
	}

	@ViewBuilder
	private func makeHeaderView(proxy: ScrollViewProxy?) -> some View {
		switch viewModel.userState {
		case .loading:
			AccountDetailHeaderView(viewModel: viewModel,
									account: .placeholder(),
									scrollViewProxy: proxy)
			.redacted(reason: .placeholder)
			.allowsHitTesting(false)
		case let .data(account):
			AccountDetailHeaderView(viewModel: viewModel,
									account: account,
									scrollViewProxy: proxy)
		case let .error(error):
			Text("Error: \(error.localizedDescription)")
		}
	}

	@ViewBuilder
	private var featuredTagsView: some View {
		if !viewModel.featuredTags.isEmpty {
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 4) {
					if !viewModel.featuredTags.isEmpty {
						ForEach(viewModel.featuredTags) { tag in
							Button {
								routerPath.navigate(to: .hashTag(tag: tag.name, account: viewModel.accountId))
							} label: {
								VStack(alignment: .leading, spacing: 0) {
									Text("#\(tag.name)")
										.font(.scaledCallout)
									Text("account.detail.featured-tags-n-posts \(tag.statusesCountInt)")
										.font(.caption2)
								}
							}.buttonStyle(.bordered)
						}
					}
				}
				.padding(.leading, .layoutPadding)
			}
		}
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
//								routerPath.navigate(to: .accountDetailWithAccount(account: account))
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
	private var buttonsView: some View {
		VStack {

			Button {
				routerPath.navigate(to: .userSavedList(id: currentUser.user?.id?.uuidString ?? ""))
			} label: {
				HStack {
					Image(systemName: "bookmark")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("Favorite List")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
						.foregroundColor(theme.tintColor)
				}
			}
			.padding(.bottom, 20)
			.buttonStyle(.borderless)

			Button {
				routerPath.navigate(to: .userOrderHistoryList(id: currentUser.user?.id?.uuidString ?? ""))
			} label: {
				HStack {
					Image(systemName: "timer")
						.font(Font.system(size: 22, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("Order History")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
				}
			}
			.buttonStyle(.borderless)

			Divider()
				.padding(.top, 20)
				.padding(.bottom, 20)

			Button {
				showingSheet.toggle()
			} label: {
				HStack {
					Image(systemName: "qrcode")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("View My QR Code")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
				}
			}
			.padding(.bottom, 20)
			.buttonStyle(.borderless)

			Button {
				isShowingScanner = true
			} label: {
				HStack {
					Image(systemName: "qrcode.viewfinder")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("Scan QR Code")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
				}
			}
			.buttonStyle(.borderless)

			Divider()
				.padding(.top, 20)
				.padding(.bottom, 20)

			Button {
				showingOptions = true
			} label: {
				HStack {
					Image(systemName: "phone")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("Contact The Collar Club")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
						.foregroundColor(theme.tintColor)
				}
			}
			.padding(.bottom, 20)
			.buttonStyle(.borderless)
			.confirmationDialog("Contact The Collar Club", isPresented: $showingOptions, titleVisibility: .visible) {
				Button("Visit Contact Page") {
					UIApplication.shared.open(URL(string: "https://collarandcomb.dog/contact/")!)
				}

				Button("Call The Collar Club") {
					Link("(800)555-1212", destination: URL(string: "tel:8005551212")!)
				}
			}

			Button {
				routerPath.presentedSheet = .membershipInfo
			} label: {
				HStack {
					Image(systemName: "person.circle")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("Account Membership Info")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
				}
			}
			.padding(.bottom, 20)
			.buttonStyle(.borderless)

			Button {
				routerPath.presentedSheet = .parkInfo
			} label: {
				HStack {
					Image(systemName: "doc.plaintext")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("Park Info")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
				}
			}
			.padding(.bottom, 20)
			.buttonStyle(.borderless)

			Button {
				routerPath.presentedSheet = .about
			} label: {
				HStack {
					Image(systemName: "doc.append")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("About The Collar Club")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
				}
			}
			.padding(.bottom, 20)
			.buttonStyle(.borderless)

			Button {
				routerPath.presentedSheet = .userAgreement
			} label: {
				HStack {
					Image(systemName: "doc.text")
						.font(Font.system(size: 24, weight: .light))
						.padding(.trailing, 20)
						.foregroundColor(theme.tintColor)

					Text("User Agreement")
						.foregroundColor(Color.text_primary_color)
						.font(.system(size: 18))
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.multilineTextAlignment(.leading)

					Spacer()

					Image(systemName: "arrow.right")
						.font(Font.system(size: 24, weight: .light))
				}
			}
			.padding(.bottom, 20)
			.buttonStyle(.borderless)

			Spacer()
				.frame(height: 40)

		}
		.listRowBackground(theme.primaryBackgroundColor)
		.listRowSeparator(.hidden)
		.listRowInsets(EdgeInsets())
	}

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			if let account = viewModel.account, displayTitle {
				VStack {
					Text(account.displayName ?? "").font(.headline)
					Text("account.detail.featured-tags-n-posts \(account.statusesCount ?? 0)")
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
			}
		}
		ToolbarItemGroup(placement: .navigationBarTrailing) {
			Menu {
				Button {
					isEditingAccount = true
				} label: {
					Label("Edit Account Info", systemImage: "pencil")
				}
			} label: {
				Image(systemName: "ellipsis.circle")
					.accessibilityLabel("accessibility.tabs.profile.options.label")
					.accessibilityInputLabels([
						LocalizedStringKey("accessibility.tabs.profile.options.label"),
						LocalizedStringKey("accessibility.tabs.profile.options.inputLabel1"),
						LocalizedStringKey("accessibility.tabs.profile.options.inputLabel2"),
					])
			}
			.confirmationDialog("Block User", isPresented: $showBlockConfirmation) {
				if let account = viewModel.account {
					Button("account.action.block-user-\(account.username)", role: .destructive) {
						Task {
							do {
								viewModel.relationship = try await client.post(endpoint: Accounts.block(id: account.id))
							} catch {
								print("Error while blocking: \(error.localizedDescription)")
							}
						}
					}
				}
			} message: {
				Text("account.action.block-user-confirmation")
			}
		}
	}
}

extension View {
	func applyAccountDetailsRowStyle(theme: Theme) -> some View {
		listRowInsets(.init())
			.listRowSeparator(.hidden)
#if !os(visionOS)
			.listRowBackground(theme.primaryBackgroundColor)
#endif
	}
}

struct AccountDetailView_Previews: PreviewProvider {
	static var previews: some View {
		AccountDetailView(user: .placeholder(), scrollToTopSignal: .constant(0))
	}
}

