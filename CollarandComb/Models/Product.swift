//
//  Status.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

enum Visibility: String, Codable, CaseIterable, Hashable, Equatable, Sendable {
	case pub = "public"
	case unlisted
	case priv = "private"
	case direct
}

protocol AnyProduct {
	var id: UUID? { get }
	var name: String { get }
	var price: String { get }
	var desc: String { get }
	var createdAt: String { get }
	var imageURL: String { get }
//	var size: String? { get }
//	var options: [String]? { get }
//	var quantity: Int { get }
//	var isMenuItem: Bool { get }
	var optionOne: String? { get }
	var optionTwo: String? { get }
	var optionThree: String? { get }
	var optionFour: String? { get }
	var optionFive: String? { get }
//	var bookmarked: Bool? { get }
//	var mediaAttachments: [MediaAttachment]? { get }
//	var filtered: [Filtered]? { get }
//	var card: Card? { get }
//	var url: String? { get }
}

final class Product: AnyProduct, Codable, Identifiable, Equatable, Hashable {

	static func == (lhs: Product, rhs: Product) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	var id: UUID?
	var name: String
	var price: String
	var desc: String
	var createdAt: String
	var imageURL: String
	var size: String?
	var options: [OptionCategory]?
//	var options: [String]?
//	var sizes: [String]?
//	var quantity: Int
//	var isMenuItem: Bool
	var optionOne: String?
	var optionTwo: String?
	var optionThree: String?
	var optionFour: String?
	var optionFive: String?

	enum CodingKeys: String, CodingKey {
		case id, name, price, desc, createdAt, imageURL, quantity, isMenuItem
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(UUID.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		price = try container.decode(String.self, forKey: .price)
		desc = try container.decode(String.self, forKey: .desc)
		createdAt = try container.decode(String.self, forKey: .createdAt)
		imageURL = try container.decode(String.self, forKey: .imageURL)
//		quantity = try container.decode(Int.self, forKey: .quantity)
//		isMenuItem = try container.decode(Bool.self, forKey: .isMenuItem)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(name, forKey: .name)
		try container.encode(price, forKey: .price)
		try container.encode(desc, forKey: .desc)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(imageURL, forKey: .imageURL)
//		try container.encode(quantity, forKey: .quantity)
//		try container.encode(isMenuItem, forKey: .isMenuItem)
	}
	
	init(id: UUID, 
		 name: String,
		 price: String,
		 desc: String,
		 createdAt: String,
		 imageURL: String,
		 size: String?,
		 options: [OptionCategory]?,
//		 options: [String]?,
//		 sizes: [String]?,
//		 quantity: Int,
//		 isMenuItem: Bool,
		 optionOne: String?,
		 optionTwo: String?,
		 optionThree: String?,
		 optionFour: String?,
		 optionFive: String?)
//		 bookmarked: Bool?)
//		 mediaAttachments: [MediaAttachment]?,
//		 visibility: Visibility?)
	{
		self.id = id
		self.name = name
		self.price = price
		self.desc = desc
		self.imageURL = imageURL
		self.size = size
		self.options = options
//		self.options = options
//		self.sizes = sizes
//		self.quantity = quantity
//		self.isMenuItem = isMenuItem
		self.optionOne = optionOne
		self.optionTwo = optionTwo
		self.optionThree = optionThree
		self.optionFour = optionFour
		self.optionFive = optionFive
		self.createdAt = createdAt
	}

	static func placeholder(forSettings: Bool = false, language: String? = nil) -> Product {
		.init(id: UUID(),
			  name: "Espresso",
			  price: "5.50",
			  desc: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren.",
			  createdAt: "2024-02-08T23:55:29Z",
			  imageURL: "https://images.unsplash.com/photo-1579992357154-faf4bde95b3d?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
			  size: "Large",
			  options: OptionCategory.placeholders(),
//			  options: nil,
//			  sizes: [],
//			  quantity: 1,
//			  isMenuItem: true,
			  optionOne: nil,
			  optionTwo: nil,
			  optionThree: nil,
			  optionFour: nil,
			  optionFive: nil
//			  bookmarked: true
//			  mediaAttachments: [MediaAttachment(id: UUID().uuidString, type: "image", url: URL(string: "https://images.unsplash.com/photo-1579992357154-faf4bde95b3d?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"), previewUrl: URL(string: "https://images.unsplash.com/photo-1579992357154-faf4bde95b3d?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"), description: "Espresso", meta: nil)], visibility: .pub
		)
	}
	
	static func placeholders() -> [Product] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}

// Every property in Status is immutable.
extension Product: Sendable {}


struct CreateProductData: Identifiable, Codable, Sendable {
	var id: UUID?
	var title: String
	var price: Double
	var desc: String
	var imageURL: String
	var size: String?
	var quantity: Int
	var isMenuItem: Bool
	var order_id: UUID
	var optionOne: String?
	var optionTwo: String?
	var optionThree: String?
	var optionFour: String?
	var optionFive: String?
}

struct FavoriteDTO: Sendable, Codable {
	let productId: String
	let customerId: String

	init(productId: String, customerId: String) {
		self.productId = productId
		self.customerId = customerId
	}
}
