//
//  User.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation

final class User: Codable, Identifiable, Hashable, Sendable, Equatable {

	static func == (lhs: User, rhs: User) -> Bool {
			lhs.id == rhs.id
	}

	var id: UUID?
	var email: String
	var bio: String?
	var firstName: String
	var lastName: String?
	var avatarImageUrl: String?
	var isVerified: Bool
//	var orderHistory: [Product]?
//	var favoriteProducts: [Product]?
	var petProfile: [PetProfile]?
	var password: String?
	var phoneNumber: String?

	init(id: UUID?, 
		 email: String,
		 bio: String?,
		 firstName: String,
		 lastName: String,
		 avatarImageUrl: String?,
		 isVerified: Bool,
//		 orderHistory: [Product]?,
//		 favoriteProducts: [Product]?,
		 petProfile: [PetProfile]?,
		 password: String?,
		 phoneNumber: String?) 
	{
		self.id = id
		self.email = email
		self.bio = bio
		self.firstName = firstName
		self.lastName = lastName
		self.avatarImageUrl = avatarImageUrl
		self.isVerified = isVerified
//		self.orderHistory = orderHistory
//		self.favoriteProducts = favoriteProducts
		self.petProfile = petProfile
		self.password = password
		self.phoneNumber = phoneNumber
	}

	static func placeholder() -> User {
		.init(id: UUID(),
			  email: "johndoe@mail.ocm",
			  bio: "This is my bio",
			  firstName: "John",
			  lastName: "Doe",
			  avatarImageUrl: nil,
			  isVerified: true,
//			  orderHistory: [],
//			  favoriteProducts: [],
			  petProfile: [],
			  password: nil,
			  phoneNumber: nil)
	}

	static func placeholders() -> [User] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension User {

	/// #The data used to create a new user.
	struct CreateData: Codable {

		/// The email address to create an account with.
		let email: String

		let firstName: String

		/// The username to create an account with.
		let username: String

		/// The password to create an account with.
		let password: String

		let verified: Bool
	}
}

extension User {

	/// #The data used to check for email address availability
	/// #for account creation.
	struct ValidateData: Codable {

		/// The email address to check availability for.
		let email: String
	}
}

extension User {
	/// #The data used to check for email address availability
	/// #for account creation.
	struct EmailCheckData: Encodable {
		/// The email address to check availability for.
		let email: String
	}

	struct EmailCheckResult: Decodable {
		let isAvailable: Bool
	}
}

struct CustomerDTO: Codable {
	let username: String
	let firstName: String
	let lastName: String
	let email: String
	let password: String
}
