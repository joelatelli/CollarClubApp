//
//  Notification.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

struct CollarNotification: Decodable, Identifiable, Equatable {
	enum NotificationType: String, CaseIterable {
		case follow, follow_request, mention, reblog, product, favourite, poll, update
	}

	let id: String
	let type: String
	let createdAt: ServerDate
	let account: Account
	let product: Product?

	var supportedType: NotificationType? {
		.init(rawValue: type)
	}

	static func placeholder() -> CollarNotification {
		.init(id: UUID().uuidString,
			  type: NotificationType.favourite.rawValue,
			  createdAt: ServerDate(),
			  account: .placeholder(),
			  product: .placeholder())
	}
}

extension CollarNotification: Sendable {}
extension CollarNotification.NotificationType: Sendable {}

