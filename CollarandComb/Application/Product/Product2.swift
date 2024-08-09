//
//  Product.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation

class Product2: Identifiable, Equatable, ObservableObject, Codable {

	static func == (lhs: Product2, rhs: Product2) -> Bool {
			lhs.id == rhs.id
	}


	var id: UUID = UUID()
	var title: String
	var price: Float
	var desc: String
	var imageURL: String
	var size: String?
	var options: [String]?
	var sizes: [String]?
	@Published var quantity: Int
	var isMenuItem: Bool
	var optionOne: String?
	var optionTwo: String?
	var optionThree: String?
	var optionFour: String?
	var optionFive: String?

	enum CodingKeys: String, CodingKey {
		case id, title, price, desc, imageURL, quantity, isMenuItem
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		title = try container.decode(String.self, forKey: .title)
		price = try container.decode(Float.self, forKey: .price)
		desc = try container.decode(String.self, forKey: .desc)
		imageURL = try container.decode(String.self, forKey: .imageURL)
		quantity = try container.decode(Int.self, forKey: .quantity)
		isMenuItem = try container.decode(Bool.self, forKey: .isMenuItem)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(price, forKey: .price)
		try container.encode(desc, forKey: .desc)
		try container.encode(imageURL, forKey: .imageURL)
		try container.encode(quantity, forKey: .quantity)
		try container.encode(isMenuItem, forKey: .isMenuItem)
	}

	init(id: UUID = UUID(), title: String, price: Float, desc: String, imageURL: String, quantity: Int, isMenuItem: Bool) {
		self.id = id
		self.title = title
		self.price = price
		self.desc = desc
		self.imageURL = imageURL
		self.quantity = quantity
		self.isMenuItem = isMenuItem
	}
}

//extension Product {
//	static var sample: [Product] =
//	[
//		Product(id: UUID(),
//				title: "Caffè Americano",
//				price: 5.50,
//				desc: "Introducing our exquisite collection of socks, where comfort meets style! Step up your fashion game and treat your feet to a shopping experience like no other. Whether you're looking for athletic performance socks, cozy winter essentials, or trendy fashion statements, we have got you covered.",
//				imageURL: "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_150,q_auto:low,fl_lossy,dpr_2.0,c_fill,f_auto,h_130/ji9833tu2k7dbm2r4mzf", sizes: ["Small", "Medium", "Large"], options: [], quantity: 1, isMenuItem: true),
//
//		Product(id: UUID(),
//				title: "Blonde Roast",
//				price: 4.50,
//				desc: "Espresso shots topped with hot water create a light layer of crema culminating in this wonderfully rich cup with depth and nuance.",
//				imageURL: "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_150,q_auto:low,fl_lossy,dpr_2.0,c_fill,f_auto,h_130/tjbhudntymgnk1znriaw", sizes: ["Small", "Medium", "Large"], options: [], quantity: 1, isMenuItem: true),
//		Product(id: UUID(),
//				title: "Cappuccino",
//				price: 5.79,
//				desc: "Our creamy and flavorful espresso combined with steamed milk and a generous amount of foam.",
//				imageURL: "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_150,q_auto:low,fl_lossy,dpr_2.0,c_fill,f_auto,h_130/x9vwxv7e0vzoaur2ixt9", sizes: ["Small", "Medium", "Large"], options: [], quantity: 1, isMenuItem: true),
//
//		Product(id: UUID(),
//				title: "Cortado",
//				price: 4.80,
//				desc: "Our creamy and flavorful espresso combined with 2 ounces of steamed milk and a very thin layer of foam. A small drink that packs a real punch.",
//				imageURL: "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_150,q_auto:low,fl_lossy,dpr_2.0,c_fill,f_auto,h_130/hoyvkbcyjemudh3z0l63", sizes: ["Small", "Medium", "Large"], options: [], quantity: 1, isMenuItem: true),
//		Product(id: UUID(),
//				title: "Cold Brew",
//				price: 5.35,
//				desc: "Our cold brew is smooth, chocolatey and slightly addictive.  Our cold brew is prepared by hand, in small batches with a 12 hour steep period.",
//				imageURL: "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_150,q_auto:low,fl_lossy,dpr_2.0,c_fill,f_auto,h_130/hxcvcvuwtr4sgbiygnll", sizes: ["Small", "Medium", "Large"], options: [], quantity: 1, isMenuItem: true),
//
//		Product(id: UUID(),
//				title: "Iced Latte",
//				price: 5.79,
//				desc: "Our velvety and flavorful Night Vision espresso balanced with your choice of milk.",
//				imageURL: "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_150,q_auto:low,fl_lossy,dpr_2.0,c_fill,f_auto,h_130/fw1ehc85dd8sd1lmbn8n", sizes: ["Small", "Medium", "Large"], options: [], quantity: 1, isMenuItem: true),
//		Product(id: UUID(),
//				title: "Iced Mocha",
//				price: 6.49,
//				desc: "Our creamy and flavorful espresso balanced with milk and our house-made chocolate.  Whipped Cream is optional but either way, our mochas are a sweet treat.",
//				imageURL: "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_150,q_auto:low,fl_lossy,dpr_2.0,c_fill,f_auto,h_130/fmqsl1xnfw3rrjns475w", sizes: ["Small", "Medium", "Large"], options: [], quantity: 1, isMenuItem: true),
//	]
//}
//
//
