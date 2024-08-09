//
//  ProductOrder.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/17/24.
//

import Foundation

final class ProductOrder: Codable, Identifiable, Equatable, Hashable {

	static func == (lhs: ProductOrder, rhs: ProductOrder) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	var id: UUID?
	var quantity: Int
	var totalPrice: Double
	var size: String
	var product: Product

	enum CodingKeys: String, CodingKey {
		case id, quantity, totalPrice, size, product
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(UUID.self, forKey: .id)
		quantity = try container.decode(Int.self, forKey: .quantity)
		totalPrice = try container.decode(Double.self, forKey: .totalPrice)
		size = try container.decode(String.self, forKey: .size)
		product = try container.decode(Product.self, forKey: .product)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(quantity, forKey: .quantity)
		try container.encode(totalPrice, forKey: .totalPrice)
		try container.encode(size, forKey: .size)
		try container.encode(product, forKey: .product)
	}

	init(id: UUID,
		 quantity: Int,
		 totalPrice: Double,
		 size: String,
		 product: Product)
	{
		self.id = id
		self.quantity = quantity
		self.totalPrice = totalPrice
		self.size = size
		self.product = product

	}

	static func placeholder(forSettings: Bool = false, language: String? = nil) -> ProductOrder {
		.init(id: UUID(),
			  quantity: 3,
			  totalPrice: 12.40,
			  size: "12 oz",
			  product: Product.placeholder()
		)
	}

	static func placeholders() -> [ProductOrder] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}

// Every property in Status is immutable.
extension ProductOrder: Sendable {}


struct ProductOrderDTO: Identifiable, Codable {
	let id: UUID?
	var quantity: Int
	var totalPrice: Double
	var size: String
	var productId: String
}
