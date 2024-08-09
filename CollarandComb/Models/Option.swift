//
//  Option.swift
//  CollarandComb
//
//  Created by Joel Muflam on 3/4/24.
//

import Foundation

final class OptionCategory: Codable, Identifiable, Equatable, Hashable {

	static func == (lhs: OptionCategory, rhs: OptionCategory) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	var id: UUID?
	var title: String
	var isOptional: Bool
	var options: [Option]

	init(id: UUID?, title: String, isOptional: Bool, options: [Option]) {
		self.id = id
		self.title = title
		self.isOptional = isOptional
		self.options = options
	}

	static func placeholder() -> OptionCategory {
		.init(id: UUID(),
			  title: "Size",
			  isOptional: true,
			  options: []
		)
	}

	static func placeholders() -> [OptionCategory] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}


final class Option: Codable, Identifiable, Equatable, Hashable {

	static func == (lhs: Option, rhs: Option) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	var id: UUID?
	var title: String
	var price: Double?

	init(id: UUID?, title: String, price: Double?) {
		self.id = id
		self.title = title
		self.price = price
	}

	static func placeholder() -> Option {
		.init(id: UUID(),
			  title: "12 Oz",
			  price: 1.25
		)
	}

	static func placeholders() -> [Option] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}
