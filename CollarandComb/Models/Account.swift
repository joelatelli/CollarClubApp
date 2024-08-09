//
//  Account.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

final class Account: Codable, Identifiable, Hashable, Sendable, Equatable {
	static func == (lhs: Account, rhs: Account) -> Bool {
		lhs.id == rhs.id &&
		lhs.username == rhs.username &&
		lhs.note.asRawText == rhs.note.asRawText &&
		lhs.statusesCount == rhs.statusesCount &&
		lhs.followersCount == rhs.followersCount &&
		lhs.followingCount == rhs.followingCount &&
		lhs.acct == rhs.acct &&
		lhs.displayName == rhs.displayName &&
		lhs.fields == rhs.fields &&
		lhs.lastStatusAt == rhs.lastStatusAt &&
		lhs.discoverable == rhs.discoverable &&
		lhs.bot == rhs.bot &&
		lhs.locked == rhs.locked &&
		lhs.avatar == rhs.avatar &&
		lhs.header == rhs.header
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	struct Field: Codable, Equatable, Identifiable, Sendable {
		var id: String {
			value.asRawText + name
		}

		let name: String
		let value: HTMLString
		let verifiedAt: String?
	}

	struct Source: Codable, Equatable, Sendable {
		let privacy: Visibility
		let sensitive: Bool
		let language: String?
		let note: String
		let fields: [Field]
	}

	let id: String
	let username: String
	let displayName: String?
	let avatar: URL
	let header: URL
	let acct: String
	let note: HTMLString
	let createdAt: ServerDate
	let followersCount: Int?
	let followingCount: Int?
	let statusesCount: Int?
	let lastStatusAt: String?
	let fields: [Field]
	let locked: Bool
	let emojis: [Emoji]
	let url: URL?
	let source: Source?
	let bot: Bool
	let discoverable: Bool?

	var haveAvatar: Bool {
		avatar.lastPathComponent != "missing.png"
	}

	var haveHeader: Bool {
		header.lastPathComponent != "missing.png"
	}

	init(id: String, username: String, displayName: String?, avatar: URL, header: URL, acct: String, note: HTMLString, createdAt: ServerDate, followersCount: Int, followingCount: Int, statusesCount: Int, lastStatusAt: String? = nil, fields: [Account.Field], locked: Bool, emojis: [Emoji], url: URL? = nil, source: Account.Source? = nil, bot: Bool, discoverable: Bool? = nil) {
		self.id = id
		self.username = username
		self.displayName = displayName
		self.avatar = avatar
		self.header = header
		self.acct = acct
		self.note = note
		self.createdAt = createdAt
		self.followersCount = followersCount
		self.followingCount = followingCount
		self.statusesCount = statusesCount
		self.lastStatusAt = lastStatusAt
		self.fields = fields
		self.locked = locked
		self.emojis = emojis
		self.url = url
		self.source = source
		self.bot = bot
		self.discoverable = discoverable
	}

	static func placeholder() -> Account {
		.init(id: UUID().uuidString,
			  username: "Username",
			  displayName: "John Mastodon",
			  avatar: URL(string: "https://files.mastodon.social/media_attachments/files/003/134/405/original/04060b07ddf7bb0b.png")!,
			  header: URL(string: "https://files.mastodon.social/media_attachments/files/003/134/405/original/04060b07ddf7bb0b.png")!,
			  acct: "johnm@example.com",
			  note: .init(stringValue: "Some content"),
			  createdAt: ServerDate(),
			  followersCount: 10,
			  followingCount: 10,
			  statusesCount: 10,
			  lastStatusAt: nil,
			  fields: [],
			  locked: false,
			  emojis: [],
			  url: nil,
			  source: nil,
			  bot: false,
			  discoverable: true)
	}

	static func placeholders() -> [Account] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}

struct FamiliarAccounts: Decodable {
	let id: String
	let accounts: [Account]
}

extension FamiliarAccounts: Sendable {}

