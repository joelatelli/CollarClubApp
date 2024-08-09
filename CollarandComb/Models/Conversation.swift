//
//  Conversation.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

struct Conversation: Identifiable, Decodable, Hashable, Equatable {
	let id: String
	let unread: Bool
	let lastProduct: Product?
	let accounts: [Account]

	init(id: String, unread: Bool, lastProduct: Product? = nil, accounts: [Account]) {
		self.id = id
		self.unread = unread
		self.lastProduct = lastProduct
		self.accounts = accounts
	}

	static func placeholder() -> Conversation {
		.init(id: UUID().uuidString, unread: false, lastProduct: .placeholder(), accounts: [.placeholder()])
	}

	static func placeholders() -> [Conversation] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}

extension Conversation: Sendable {}

