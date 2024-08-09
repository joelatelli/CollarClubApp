//
//  Router.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Combine
import Foundation
import Network
import Observation
import SwiftUI

enum RouterDestination: Hashable {
	case accountDetail(id: String)
	case accountDetailWithAccount(user: User)
	case accountSettingsWithAccount(account: Account, appAccount: AppAccount)
	case statusDetail(id: String)
	case statusDetailWithStatus(status: Product)
	case remoteStatusDetail(url: URL)
	case conversationDetail(conversation: Conversation)
	case hashTag(tag: String, account: String?)
	case list(list: CollarList)
	case followers(id: String)
	case following(id: String)
	case favoritedBy(id: String)
	case rebloggedBy(id: String)
	case accountsList(accounts: [Account])
	case trendingTimeline
	case trendingLinks(cards: [Card])
	case tagsList(tags: [Tag])
	case orderDetail(products: [ProductOrder])
	case userSavedList(id: String)
	case userOrderHistoryList(id: String)
	case profileDetail(profile: PetProfile)
}

enum WindowDestinationEditor: Hashable, Codable {
	case newStatusEditor(visibility: Visibility)
	case editStatusEditor(status: Product)
	case replyToStatusEditor(status: Product)
	case quoteStatusEditor(status: Product)
	case mentionStatusEditor(account: Account, visibility: Visibility)
}

enum WindowDestinationMedia: Hashable, Codable {
	case mediaViewer(attachments: [MediaAttachment], selectedAttachment: MediaAttachment)
}

enum SheetDestination: Identifiable {
	case newStatusEditor(visibility: Visibility)
	case editStatusEditor(status: Product)
	case listCreate
	case listEdit(list: CollarList)
	case listAddAccount(account: Account)
	case addAccount
	case addRemoteLocalTimeline
	case addTagGroup
	case statusEditHistory(status: String)
	case settings
	case about
	case parkInfo
	case membershipInfo
	case userAgreement
	case support
	case accountPushNotficationsSettings
	case report(status: Product)
	case shareImage(image: UIImage, status: Product)
	case editTagGroup(tagGroup: TagGroup, onSaved: ((TagGroup) -> Void)?)
	case timelineContentFilter
	case editProfile(profile: PetProfile)
	case newProfile

	public var id: String {
		switch self {
		case .editStatusEditor, .newStatusEditor:
			"statusEditor"
		case .listCreate:
			"listCreate"
		case .listEdit:
			"listEdit"
		case .listAddAccount:
			"listAddAccount"
		case .addAccount:
			"addAccount"
		case .addTagGroup:
			"addTagGroup"
		case .addRemoteLocalTimeline:
			"addRemoteLocalTimeline"
		case .statusEditHistory:
			"statusEditHistory"
		case .report:
			"report"
		case .shareImage:
			"shareImage"
		case .editTagGroup:
			"editTagGroup"
		case .settings, .support, .about, .userAgreement, .parkInfo, .membershipInfo, .accountPushNotficationsSettings:
			"settings"
		case .timelineContentFilter:
			"timelineContentFilter"
		case .editProfile, .newProfile:
			"timelineContentFilter"
		}
	}
}

@MainActor
@Observable class RouterPath {
	var client: Client?
	var urlHandler: ((URL) -> OpenURLAction.Result)?
	
	var path: [RouterDestination] = []
	var presentedSheet: SheetDestination?
	
	init() {}
	
	func navigate(to: RouterDestination) {
		path.append(to)
	}
	
	func handleStatus(status: AnyProduct, url: URL) -> OpenURLAction.Result {
		if let client,
		   client.isAuth,
		   client.hasConnection(with: url),
		   let id = Int(url.lastPathComponent)
		{
			if !StatusEmbedCache.shared.badProductsURLs.contains(url) {
				if url.absoluteString.contains(client.server) {
					navigate(to: .statusDetail(id: String(id)))
				} else {
					navigate(to: .remoteStatusDetail(url: url))
				}
				return .handled
			}
		}
		return urlHandler?(url) ?? .systemAction
	}
	
	public func handle(url: URL) -> OpenURLAction.Result {
		if url.pathComponents.contains(where: { $0 == "tags" }),
		   let tag = url.pathComponents.last
		{
			navigate(to: .hashTag(tag: tag, account: nil))
			return .handled
		} else if url.lastPathComponent.first == "@",
				  let host = url.host,
				  !host.hasPrefix("www") {
			let acct = "\(url.lastPathComponent)@\(host)"
			Task {
				await navigateToAccountFrom(acct: acct, url: url)
			}
			return .handled
		} else if let client,
				  client.isAuth,
				  client.hasConnection(with: url),
				  let id = Int(url.lastPathComponent)
		{
			if url.absoluteString.contains(client.server) {
				navigate(to: .statusDetail(id: String(id)))
			} else {
				navigate(to: .remoteStatusDetail(url: url))
			}
			return .handled
		}
		return urlHandler?(url) ?? .systemAction
	}
	
	public func navigateToAccountFrom(acct: String, url: URL) async {
		guard let client else { return }
		let results: SearchResults? = try? await client.get(endpoint: Search.search(query: acct,
																					type: "accounts",
																					offset: nil,
																					following: nil),
															forceVersion: .v2)
		if let account = results?.accounts.first {
//			navigate(to: .accountDetailWithAccount(account: account))
		} else {
			_ = await UIApplication.shared.open(url)
		}
	}
	
	public func navigateToAccountFrom(url: URL) async {
		guard let client else { return }
		let results: SearchResults? = try? await client.get(endpoint: Search.search(query: url.absoluteString,
																					type: "accounts",
																					offset: nil,
																					following: nil),
															forceVersion: .v2)
		if let account = results?.accounts.first {
//			navigate(to: .accountDetailWithAccount(account: account))
		} else {
			_ = await UIApplication.shared.open(url)
		}
	}
}

