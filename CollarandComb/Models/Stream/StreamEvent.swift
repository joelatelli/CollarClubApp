//
//  StreamEvent.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

struct RawStreamEvent: Decodable {
	let event: String
	let stream: [String]
	let payload: String
}

protocol StreamEvent: Identifiable {
	var date: Date { get }
	var id: String { get }
}

struct StreamEventUpdate: StreamEvent {
	let date = Date()
	var id: String { product.id!.uuidString }
	let product: Product
	init(product: Product) {
		self.product = product
	}
}

struct StreamEventStatusUpdate: StreamEvent {
	let date = Date()
	var id: String { product.id!.uuidString}
	let product: Product
	init(product: Product) {
		self.product = product
	}
}

struct StreamEventDelete: StreamEvent {
	let date = Date()
	var id: String { status + date.description }
	let status: String
	init(status: String) {
		self.status = status
	}
}

struct StreamEventNotification: StreamEvent {
	let date = Date()
	var id: String { notification.id }
	let notification: CollarNotification
	init(notification: CollarNotification) {
		self.notification = notification
	}
}

struct StreamEventConversation: StreamEvent {
	let date = Date()
	var id: String { conversation.id }
	let conversation: Conversation
	init(conversation: Conversation) {
		self.conversation = conversation
	}
}

