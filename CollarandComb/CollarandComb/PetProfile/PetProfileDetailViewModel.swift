//
//  PetProfileDetailViewModel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import Observation
import SwiftUI

@MainActor
@Observable class PetProfileDetailViewModel {
	let profileId: String
	var client: Client?
	var isCurrentUser: Bool = false

	enum ProfileState {
		case loading, data(profile: PetProfile), error(error: Error)
	}

	enum Tab: Int {
		case statuses, favorites, bookmarks, replies, boosts, media

		static var currentAccountTabs: [Tab] {
			[.statuses, .replies, .boosts, .favorites, .bookmarks]
		}

		static var accountTabs: [Tab] {
			[.statuses, .replies, .boosts, .media]
		}

		var iconName: String {
			switch self {
			case .statuses: "bubble.right"
			case .favorites: "star"
			case .bookmarks: "bookmark"
			case .replies: "bubble.left.and.bubble.right"
			case .boosts: ""
			case .media: "photo.on.rectangle.angled"
			}
		}

		var accessibilityLabel: LocalizedStringKey {
			switch self {
			case .statuses: "accessibility.tabs.profile.picker.statuses"
			case .favorites: "accessibility.tabs.profile.picker.favorites"
			case .bookmarks: "accessibility.tabs.profile.picker.bookmarks"
			case .replies: "accessibility.tabs.profile.picker.posts-and-replies"
			case .boosts: "accessibility.tabs.profile.picker.boosts"
			case .media: "accessibility.tabs.profile.picker.media"
			}
		}
	}

	var profileState: ProfileState = .loading

	var relationship: Relationship?

	private var favoritesNextPage: LinkHandler?
	private var bookmarksNextPage: LinkHandler?
	var featuredTags: [FeaturedTag] = []
	var fields: [Account.Field] = []
	var familiarFollowers: [Account] = []
	var selectedTab = Tab.statuses {
		didSet {
			switch selectedTab {
			case .statuses, .replies, .boosts, .media:
				tabTask?.cancel()
				tabTask = Task {
					await fetchNewestStatuses(pullToRefresh: false)
				}
			default:
				reloadTabState()
			}
		}
	}

	var scrollToTopVisible: Bool = false

	var translation: Translation?
	var isLoadingTranslation = false

	private(set) var profile: PetProfile?
	private var tabTask: Task<Void, Never>?


	/// When coming from a URL like a mention tap in a status.
	init(profileId: String) {
		self.profileId = profileId
	}

	/// When the account is already fetched by the parent caller.
	init(profile: PetProfile) {
		profileId = profile.id!.uuidString
		self.profile = profile
		profileState = .data(profile: profile)
	}

	func fetchAccount() async {
//		guard let client else { return }
//		do {
//			let data = try await fetchAccountData(accountId: accountId, client: client)
//			accountState = .data(account: data.account)
//
//			account = data.account
//			fields = data.account.fields
//			featuredTags = data.featuredTags
//			featuredTags.sort { $0.statusesCountInt > $1.statusesCountInt }
//			relationship = data.relationships.first
//		} catch {
//			if let account {
//				accountState = .data(account: account)
//			} else {
//				accountState = .error(error: error)
//			}
//		}
	}

	func fetchFamilliarFollowers() async {
//		let familiarFollowers: [FamiliarAccounts]? = try? await client?.get(endpoint: Accounts.familiarFollowers(withAccount: accountId))
//		self.familiarFollowers = familiarFollowers?.first?.accounts ?? []
	}

	func fetchNewestStatuses(pullToRefresh: Bool) async {
//		guard let client else { return }
//		do {
//			statusesState = .loading
//			boosts = []
//			statuses =
//			try await client.get(endpoint: Accounts.statuses(id: accountId,
//															 sinceId: nil,
//															 tag: nil,
//															 onlyMedia: selectedTab == .media,
//															 excludeReplies: selectedTab != .replies,
//															 excludeReblogs: selectedTab != .boosts,
//															 pinned: nil))
//			StatusDataControllerProvider.shared.updateDataControllers(for: statuses, client: client)
//			if selectedTab == .boosts {
//				boosts = statuses.filter{ $0.reblog != nil }
//			}
//			if selectedTab == .statuses {
//				pinned =
//				try await client.get(endpoint: Accounts.statuses(id: accountId,
//																 sinceId: nil,
//																 tag: nil,
//																 onlyMedia: false,
//																 excludeReplies: false,
//																 excludeReblogs: false,
//																 pinned: true))
//				StatusDataControllerProvider.shared.updateDataControllers(for: pinned, client: client)
//			}
//			if isCurrentUser {
//				(favorites, favoritesNextPage) = try await client.getWithLink(endpoint: Accounts.favorites(sinceId: nil))
//				(bookmarks, bookmarksNextPage) = try await client.getWithLink(endpoint: Accounts.bookmarks(sinceId: nil))
//				StatusDataControllerProvider.shared.updateDataControllers(for: favorites, client: client)
//				StatusDataControllerProvider.shared.updateDataControllers(for: bookmarks, client: client)
//			}
//			reloadTabState()
//		} catch {
//			statusesState = .error(error: error)
//		}
	}

	func fetchNextPage() async {
		guard let client else { return }
//		do {
//			switch selectedTab {
//			case .statuses, .replies, .boosts, .media:
//				guard let lastId = statuses.last?.id else { return }
//				if selectedTab == .boosts {
//					statusesState = .display(statuses: boosts, nextPageState: .loadingNextPage)
//				} else {
//					statusesState = .display(statuses: statuses, nextPageState: .loadingNextPage)
//				}
//				let newStatuses: [Status] =
//				try await client.get(endpoint: Accounts.statuses(id: accountId,
//																 sinceId: lastId,
//																 tag: nil,
//																 onlyMedia: selectedTab == .media,
//																 excludeReplies: selectedTab != .replies,
//																 excludeReblogs: selectedTab != .boosts,
//																 pinned: nil))
//				statuses.append(contentsOf: newStatuses)
//				if selectedTab == .boosts {
//					let newBoosts = statuses.filter{ $0.reblog != nil }
//					self.boosts.append(contentsOf: newBoosts)
//				}
//				StatusDataControllerProvider.shared.updateDataControllers(for: newStatuses, client: client)
//				if selectedTab == .boosts {
//					statusesState = .display(statuses: boosts,
//											 nextPageState: newStatuses.count < 20 ? .none : .hasNextPage)
//				} else {
//					statusesState = .display(statuses: statuses,
//											 nextPageState: newStatuses.count < 20 ? .none : .hasNextPage)
//				}
//			case .favorites:
//				guard let nextPageId = favoritesNextPage?.maxId else { return }
//				let newFavorites: [Status]
//				(newFavorites, favoritesNextPage) = try await client.getWithLink(endpoint: Accounts.favorites(sinceId: nextPageId))
//				favorites.append(contentsOf: newFavorites)
//				StatusDataControllerProvider.shared.updateDataControllers(for: newFavorites, client: client)
//				statusesState = .display(statuses: favorites, nextPageState: .hasNextPage)
//			case .bookmarks:
//				guard let nextPageId = bookmarksNextPage?.maxId else { return }
//				let newBookmarks: [Status]
//				(newBookmarks, bookmarksNextPage) = try await client.getWithLink(endpoint: Accounts.bookmarks(sinceId: nextPageId))
//				StatusDataControllerProvider.shared.updateDataControllers(for: newBookmarks, client: client)
//				bookmarks.append(contentsOf: newBookmarks)
//				statusesState = .display(statuses: bookmarks, nextPageState: .hasNextPage)
//			}
//		} catch {
//			statusesState = .error(error: error)
//		}
	}

	func deleteProfile() {
		NetWorkManager.deletePostRequestWithoutReturn(sending: profile!.id!,
													path: "delete-profile/\(profileId)/",
													authType: .none
		) { result in
			switch result {
			case .success:
				print("Delete Pet Profile Completed ---")
			case .failure(let error):
				print("Delete Pet Profile ERROR ---")
			}
		}
	}

	func delete() async {
		do {
//			  StreamWatcher.shared.emmitDeleteEvent(for: status.id)
			_ = try await client!.delete(endpoint: Collars.deleteProfile(id: profileId))
		} catch {}
	}

	private func reloadTabState() {
//		switch selectedTab {
//		case .statuses, .replies, .media:
//			statusesState = .display(statuses: statuses, nextPageState: statuses.count < 20 ? .none : .hasNextPage)
//		case .boosts:
//			statusesState = .display(statuses: boosts, nextPageState: statuses.count < 20 ? .none : .hasNextPage)
//		case .favorites:
//			statusesState = .display(statuses: favorites,
//									 nextPageState: favoritesNextPage != nil ? .hasNextPage : .none)
//		case .bookmarks:
//			statusesState = .display(statuses: bookmarks,
//									 nextPageState: bookmarksNextPage != nil ? .hasNextPage : .none)
//		}
	}


	func statusDidAppear(status _: PetProfile) {}

	func statusDidDisappear(status _: PetProfile) {}

	func translate(userLang: String) async {
//		guard let account else { return }
//		withAnimation {
//			isLoadingTranslation = true
//		}
//
//		let userAPIKey = DeepLUserAPIHandler.readIfAllowed()
//		let userAPIFree = UserPreferences.shared.userDeeplAPIFree
//		let deeplClient = DeepLClient(userAPIKey: userAPIKey, userAPIFree: userAPIFree)
//
//		let translation = try? await deeplClient.request(target: userLang, text: account.note.asRawText)
//
//		withAnimation {
//			self.translation = translation
//			isLoadingTranslation = false
//		}
	}
}

