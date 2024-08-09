//
//  ConsolidatedNotification.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

struct ConsolidatedNotification: Identifiable {
	let notifications: [CollarNotification]
	let type: CollarNotification.NotificationType
	let createdAt: ServerDate
	let accounts: [Account]
	let product: Product?

	public var id: String? { notifications.first?.id }

	public init(notifications: [CollarNotification],
				type: CollarNotification.NotificationType,
				createdAt: ServerDate,
				accounts: [Account],
				product: Product?)
	{
		self.notifications = notifications
		self.type = type
		self.createdAt = createdAt
		self.accounts = accounts
		self.product = product ?? nil
	}

	public static func placeholder() -> ConsolidatedNotification {
		.init(notifications: [CollarNotification.placeholder()],
			  type: .favourite,
			  createdAt: ServerDate(),
			  accounts: [.placeholder()],
			  product: .placeholder())
	}

	public static func placeholders() -> [ConsolidatedNotification] {
		[.placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder()]
	}
}

extension ConsolidatedNotification: Sendable {}

