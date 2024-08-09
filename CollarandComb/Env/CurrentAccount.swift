//
//  CurrentAccount.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Combine
import Foundation
import Network
import Observation

@MainActor
@Observable class CurrentAccount {
	private static var accountsCache: [String: Account] = [:]

	private(set) var user: User?
	private(set) var account: Account?
	private(set) var isUpdating: Bool = false
	private(set) var isLoadingAccount: Bool = false

	private var client: Client?

	static let shared = CurrentAccount()

	var sortedTags: [Tag] {
		//	tags.sorted { $0.name.lowercased() < $1.name.lowercased() }
		[]
	}

	private init() {}

	func setClient(client: Client) {
		self.client = client
		guard client.isAuth else { return }
		Task(priority: .userInitiated) {
			await fetchUserData()
		}
	}

	private func fetchUserData() async {
		await withTaskGroup(of: Void.self) { group in
			group.addTask { await self.fetchCurrentAccount() }
			group.addTask { await self.fetchConnections() }
			group.addTask { await self.fetchLists() }
			group.addTask { await self.fetchFollowedTags() }
			group.addTask { await self.fetchFollowerRequests() }
		}
	}

	func fetchConnections() async {
		//	guard let client else { return }
		//	do {
		//	  let connections: [String] = try await client.get(endpoint: Instances.peers)
		//	  client.addConnections(connections)
		//	} catch {}
	}

	func fetchCurrentAccount() async {
		guard let client, client.isAuth else {
			account = nil
			return
		}
		account = Self.accountsCache[client.id]
		if account == nil {
			isLoadingAccount = true
		}
		account = try? await client.get(endpoint: Accounts.verifyCredentials)
		isLoadingAccount = false
		Self.accountsCache[client.id] = account
	}

	func fetchLists() async {
		//	guard let client, client.isAuth else { return }
		//	do {
		//	  lists = try await client.get(endpoint: lists)
		//	} catch {
		//	  lists = []
		//	}
	}

	func fetchFollowedTags() async {
		//	guard let client, client.isAuth else { return }
		//	do {
		//	  tags = try await client.get(endpoint: Accounts.followedTags)
		//	} catch {
		//	  tags = []
		//	}
	}

	func followTag(id: String) async -> Tag? {
		//	guard let client else { return nil }
		//	do {
		//	  let tag: Tag = try await client.post(endpoint: Tags.follow(id: id))
		//	  tags.append(tag)
		//	  return tag
		//	} catch {
		return nil
		//	}
	}

	func unfollowTag(id: String) async -> Tag? {
		//	guard let client else { return nil }
		//	do {
		//	  let tag: Tag = try await client.post(endpoint: Tags.unfollow(id: id))
		//	  tags.removeAll { $0.id == tag.id }
		//	  return tag
		//	} catch {
		return nil
		//	}
	}

	func fetchFollowerRequests() async {
		//	guard let client else { return }
		//	do {
		//	  followRequests = try await client.get(endpoint: FollowRequests.list)
		//	} catch {
		//	  followRequests = []
		//	}
	}

	func acceptFollowerRequest(id: String) async {
		//	guard let client else { return }
		//	do {
		//	  updatingFollowRequestAccountIds.insert(id)
		//	  defer {
		//		updatingFollowRequestAccountIds.remove(id)
		//	  }
		//	  _ = try await client.post(endpoint: FollowRequests.accept(id: id))
		//	  await fetchFollowerRequests()
		//	} catch {}
	}

	func rejectFollowerRequest(id: String) async {
		//	guard let client else { return }
		//	do {
		//	  updatingFollowRequestAccountIds.insert(id)
		//	  defer {
		//		updatingFollowRequestAccountIds.remove(id)
		//	  }
		//	  _ = try await client.post(endpoint: FollowRequests.reject(id: id))
		//	  await fetchFollowerRequests()
		//	} catch {}
	}
}

