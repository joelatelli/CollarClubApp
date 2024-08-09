//
//  Order.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/28/23.
//

import Foundation

protocol AnyOrder {
	var id: UUID? { get }
	var user: User? { get }
	var products: [Product]? { get }
	var createdAt: Date? { get }
	var isCompleted: Bool { get }
	var completedAt: Date? { get }
	var total: Float? { get }
}

final class Order: AnyOrder, Codable, Identifiable, Equatable, Hashable {

	static func == (lhs: Order, rhs: Order) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	var id: UUID?
	var user: User?
	var products: [Product]?
	var createdAt: Date?
	var isCompleted: Bool
	var completedAt: Date?
	var total: Float?

	init(id: UUID?, user: User?,  products: [Product]?, createdAt: Date?, isCompleted: Bool, completedAt: Date?, total: Float?) {
		self.id = id
		self.user = user
		self.products = products
		self.createdAt = createdAt
		self.isCompleted = isCompleted
		self.completedAt = completedAt
		self.total = total
	}

	static func placeholder(forSettings: Bool = false, language: String? = nil) -> Order {
		.init(id: UUID(),
			  user: nil,
			  products: Product.placeholders(),
			  createdAt: Date(),
			  isCompleted: true,
			  completedAt: Date(),
			  total: 16.50
		)
	}

	static func placeholders() -> [Order] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}


struct OrderDTO: Codable {
	let status: String
	let paymentMethod: String
	let customerId: String
	let products: [ProductOrderDTO]
}
