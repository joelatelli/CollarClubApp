//
//  CollarAndCombListViewModel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import Observation
import SwiftUI

public enum CollarAndCombListListMode {
	case collarAndComb(accountId: String)

	var title: LocalizedStringKey {
		switch self {
		case .collarAndComb:
			"Collar and Foam"
		}
	}
}

@MainActor
@Observable class CollarAndCombListViewModel {
	var client: Client?

	let mode: CollarAndCombListListMode

	public enum State {
		public enum PagingState {
			case hasNextPage, loadingNextPage, none
		}

		case loading
		case display(profiles: [PetProfile],
					 nextPageState: PagingState)
		case error(error: Error)
	}

	public enum ServicesState {
		public enum PagingState {
			case hasNextPage, loadingNextPage, none
		}

		case loading
		case display(accounts: [PetProfile])
		case error(error: Error)
	}

	private var profiles: [PetProfile] = []
	private var relationships: [Relationship] = []

	var state = State.loading
	var serviceState = ServicesState.loading

	var totalCount: Int?
	var accountId: String?

	var searchQuery: String = ""

	private var nextPageId: String?

	var limit: Int?
	var total: Int?
	var page: Int = 1

	var hasMoreData: Bool {
	   guard let limit = limit, let total = total else {
		   return true
	   }
	   return profiles.count < total && profiles.count < limit * page
	}

	init(mode: CollarAndCombListListMode) {
		self.mode = mode
	}

	func fetch() async {
		guard let client else { return }
		do {
			state = .loading
			page = 1
			let response: [PetProfile] = try await client.get(endpoint: Collars.myProfiles(id: accountId ?? "fbb3940a-91a1-46e4-9a4a-f8cdb170cc04", limit: limit ?? 20, page: page))

//			profiles = response.data
//			limit = response.limit
//			total = response.total
//			page += 1

			state = .display(profiles: response, nextPageState: .none)
		} catch {
			state = .error(error: error)
		}
	}

	func fetchNextPage() async {
		guard let client, let nextPageId else { return }
//		do {
//			state = .display(accounts: accounts, relationships: relationships, nextPageState: .loadingNextPage)
//			let newAccounts: [Account]
//			let link: LinkHandler?
//			switch mode {
//			case let .followers(accountId):
//				(newAccounts, link) = try await client.getWithLink(endpoint: Accounts.followers(id: accountId,
//																								maxId: nextPageId))
//			case let .following(accountId):
//				(newAccounts, link) = try await client.getWithLink(endpoint: Accounts.following(id: accountId,
//																								maxId: nextPageId))
//			case let .rebloggedBy(statusId):
//				(newAccounts, link) = try await client.getWithLink(endpoint: Statuses.rebloggedBy(id: statusId,
//																								  maxId: nextPageId))
//			case let .favoritedBy(statusId):
//				(newAccounts, link) = try await client.getWithLink(endpoint: Statuses.favoritedBy(id: statusId,
//																								  maxId: nextPageId))
//			case .accountsList:
//				newAccounts = []
//				link = nil
//			}
//			accounts.append(contentsOf: newAccounts)
//			let newRelationships: [Relationship] =
//			try await client.get(endpoint: Accounts.relationships(ids: newAccounts.map(\.id)))
//
//			relationships.append(contentsOf: newRelationships)
//			self.nextPageId = link?.maxId
//			state = .display(accounts: accounts,
//							 relationships: relationships,
//							 nextPageState: link?.maxId != nil ? .hasNextPage : .none)
//		} catch {
//			print(error)
//		}
	}

	func search() async {
		guard let client, !searchQuery.isEmpty else { return }
//		do {
//			state = .loading
//			try await Task.sleep(for: .milliseconds(250))
//			var results: SearchResults = try await client.get(endpoint: Search.search(query: searchQuery,
//																					  type: "accounts",
//																					  offset: nil,
//																					  following: true),
//															  forceVersion: .v2)
//			let relationships: [Relationship] =
//			try await client.get(endpoint: Accounts.relationships(ids: results.accounts.map(\.id)))
//			results.relationships = relationships
//			withAnimation {
//				state = .display(accounts: results.accounts,
//								 relationships: relationships,
//								 nextPageState: .none)
//			}
//		} catch {
//
//		}
	}
}
