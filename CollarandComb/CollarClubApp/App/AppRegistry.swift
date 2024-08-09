//
//  AppRegistry.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import LinkPresentation
import SwiftUI

@MainActor
extension View {
	func withAppRouter() -> some View {
		navigationDestination(for: RouterDestination.self) { destination in
			switch destination {
			case let .accountDetail(id):
				EmptyView()
//				AccountDetailView(accountId: id, scrollToTopSignal: .constant(0))
			case let .accountDetailWithAccount(user):
				AccountDetailView(user: user, scrollToTopSignal: .constant(0))
			case let .accountSettingsWithAccount(account, appAccount):
				EmptyView()
//				AccountSettingsView(account: account, appAccount: appAccount)
			case let .statusDetail(id):
				ProductDetailView(statusId: id)
			case let .statusDetailWithStatus(status):
				ProductDetailView(status: status)
			case let .remoteStatusDetail(url):
				ProductDetailView(remoteStatusURL: url)
			case let .conversationDetail(conversation):
				EmptyView()
//				ConversationDetailView(conversation: conversation)
			case let .hashTag(tag, accountId):
				EmptyView()
//				TimelineView(timeline: .constant(.hashtag(tag: tag, accountId: accountId)),
//							 pinnedFilters: .constant([]),
//							 selectedTagGroup: .constant(nil),
//							 scrollToTopSignal: .constant(0),
//							 canFilterTimeline: false)
			case let .list(list):
				EmptyView()
//				TimelineView(timeline: .constant(.list(list: list)),
//							 pinnedFilters: .constant([]),
//							 selectedTagGroup: .constant(nil),
//							 scrollToTopSignal: .constant(0),
//							 canFilterTimeline: false)
			case let .following(id):
				EmptyView()
//				AccountsListView(mode: .following(accountId: id))
			case let .followers(id):
				EmptyView()
//				AccountsListView(mode: .followers(accountId: id))
			case let .favoritedBy(id):
				EmptyView()
//				AccountsListView(mode: .favoritedBy(statusId: id))
			case let .rebloggedBy(id):
				EmptyView()
//				AccountsListView(mode: .rebloggedBy(statusId: id))
			case let .accountsList(accounts):
				EmptyView()
//				AccountsListView(mode: .accountsList(accounts: accounts))
			case .trendingTimeline:
				EmptyView()
//				TimelineView(timeline: .constant(.trending),
//							 pinnedFilters: .constant([]),
//							 selectedTagGroup: .constant(nil),
//							 scrollToTopSignal: .constant(0),
//							 canFilterTimeline: false)
			case let .trendingLinks(cards):
				EmptyView()
//				CardsListView(cards: cards)
			case let .tagsList(tags):
				EmptyView()
//				TagsListView(tags: tags)
			case let .orderDetail(products):
				CartOrderListView(products: products)
			case let .userSavedList(id):
				ProductTimelineListView(mode: .saved(accountId: id))
			case let .userOrderHistoryList(id):
				OrderHistoryListView(mode: .user(id: id))
			case let .profileDetail(profile):
				PetProfileDetailView(profile: profile)
			}
		}
	}

	func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
		sheet(item: sheetDestinations) { destination in
			switch destination {
			case let .newStatusEditor(visibility):
				ProductEditor.MainView(mode: .new(visibility: visibility))
					.withEnvironments()
			case let .editStatusEditor(status):
				ProductEditor.MainView(mode: .edit(product: status))
					.withEnvironments()
			case .listCreate:
				EmptyView()
//				ListCreateView()
//					.withEnvironments()
			case let .listEdit(list):
				EmptyView()
//				ListEditView(list: list)
//					.withEnvironments()
			case let .listAddAccount(account):
				EmptyView()
//				ListAddAccountView(account: account)
//					.withEnvironments()
			case .addAccount:
				EmptyView()
//				AddAccountView()
//					.withEnvironments()
			case .addRemoteLocalTimeline:
				EmptyView()
//				AddRemoteTimelineView()
//					.withEnvironments()
			case .addTagGroup:
				EmptyView()
//				EditTagGroupView()
//					.withEnvironments()
			case let .statusEditHistory(status):
				EmptyView()
//				StatusEditHistoryView(statusId: status)
//					.withEnvironments()
			case .settings:
				EmptyView()
//				SettingsTabs(popToRootTab: .constant(.settings), isModal: true)
//					.withEnvironments()
//					.preferredColorScheme(Theme.shared.selectedScheme == .dark ? .dark : .light)
			case .accountPushNotficationsSettings:
				if let subscription = PushNotificationsService.shared.subscriptions.first(where: { $0.account.token == AppAccountsManager.shared.currentAccount.oauthToken }) {
					NavigationSheet { PushNotificationsView(subscription: subscription) }
						.withEnvironments()
				} else {
					EmptyView()
				}
			case .about:
				NavigationSheet { AboutView() }
					.withEnvironments()
			case .parkInfo:
				NavigationSheet { ParkInfoView() }
					.withEnvironments()
			case .membershipInfo:
				NavigationSheet { MembershipInfoView() }
					.withEnvironments()
			case .userAgreement:
				NavigationSheet { UserAgreementView() }
					.withEnvironments()
			case .support:
				NavigationSheet { SupportAppView() }
					.withEnvironments()
			case let .report(status):
				EmptyView()
//				ReportView(status: status)
//					.withEnvironments()
			case let .shareImage(image, status):
				ActivityView(image: image, status: status)
					.withEnvironments()
			case let .editTagGroup(tagGroup, onSaved):
				EmptyView()
//				EditTagGroupView(tagGroup: tagGroup, onSaved: onSaved)
//					.withEnvironments()
			case .timelineContentFilter:
				EmptyView()
//				NavigationSheet { TimelineContentFilterView() }
//					.presentationDetents([.medium])
//					.withEnvironments()
			case let .editProfile(profile):
				EditPetProfileView(mode: .edit(profile: profile))
			case .newProfile:
				EditPetProfileView(mode: .new)
			}
		}
	}

	func withEnvironments() -> some View {
		environment(CurrentAccount.shared)
			.environment(UserPreferences.shared)
			.environment(CurrentInstance.shared)
			.environment(Theme.shared)
			.environment(AppAccountsManager.shared)
			.environment(PushNotificationsService.shared)
			.environment(AppAccountsManager.shared.currentClient)
			.environment(QuickLook.shared)
	}

	func withModelContainer() -> some View {
		modelContainer(for: [
			Draft.self,
			LocalTimeline.self,
			TagGroup.self,
			RecentTag.self,
		])
	}
}

struct ActivityView: UIViewControllerRepresentable {
	let image: UIImage
	let status: Product

	class LinkDelegate: NSObject, UIActivityItemSource {
		let image: UIImage
		let status: Product

		init(image: UIImage, status: Product) {
			self.image = image
			self.status = status
		}

		func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
			let imageProvider = NSItemProvider(object: image)
			let metadata = LPLinkMetadata()
			metadata.imageProvider = imageProvider
			metadata.title = status.name
			return metadata
		}

		func activityViewControllerPlaceholderItem(_: UIActivityViewController) -> Any {
			image
		}

		func activityViewController(_: UIActivityViewController,
									itemForActivityType _: UIActivity.ActivityType?) -> Any?
		{
			nil
		}
	}

	func makeUIViewController(context _: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
		UIActivityViewController(activityItems: [image, LinkDelegate(image: image, status: status)],
								 applicationActivities: nil)
	}

	func updateUIViewController(_: UIActivityViewController, context _: UIViewControllerRepresentableContext<ActivityView>) {}
}

extension URL: Identifiable {
	public var id: String {
		absoluteString
	}
}

