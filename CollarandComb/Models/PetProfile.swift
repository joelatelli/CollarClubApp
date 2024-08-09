//
//  PetProfile.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/28/23.
//

import Foundation

final class PetProfile: Codable, Identifiable, Hashable, Sendable, Equatable {

	static func == (lhs: PetProfile, rhs: PetProfile) -> Bool {
			lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	var id: UUID?
	var name: String?
	var age: String?
	var breed: String?
	var weight: String?
	var temperment: String?
	var specialNeeds: String?
	var lastVaccinated: String?
//	let avatar: URL?
//	let header: URL?

//	var haveAvatar: Bool {
//		avatar?.lastPathComponent != "missing.png"
//	}
//
//	var haveHeader: Bool {
//		header?.lastPathComponent != "missing.png"
//	}

	init(id: UUID? = nil, 
		 name: String?,
		 age: String?,
		 breed: String?,
		 weight: String?,
		 temperment: String?,
		 specialNeeds: String?,
		 lastVaccinated: String?
//		 , avatar: URL?, header: URL?
	) {
		self.id = id
		self.name = name
		self.age = age
		self.breed = breed
		self.weight = weight
		self.temperment = temperment
		self.specialNeeds = specialNeeds
		self.lastVaccinated = lastVaccinated
//		self.avatar = avatar
//		self.header = header
	}

	enum CodingKeys: String, CodingKey {
		case id, name, age, breed, weight, temperment, specialNeeds, lastVaccinated
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id  = try container.decode(UUID.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		age = try container.decode(String.self, forKey: .age)
		breed = try container.decode(String.self, forKey: .breed)
		weight = try container.decode(String.self, forKey: .weight)
		temperment = try container.decode(String.self, forKey: .temperment)
		specialNeeds = try container.decode(String.self, forKey: .specialNeeds)
		lastVaccinated = try container.decode(String.self, forKey: .lastVaccinated)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(name, forKey: .name)
		try container.encode(age, forKey: .age)
		try container.encode(breed, forKey: .breed)
		try container.encode(temperment, forKey: .temperment)
		try container.encode(specialNeeds, forKey: .specialNeeds)
		try container.encode(lastVaccinated, forKey: .lastVaccinated)
	}

	static func placeholder() -> PetProfile {
		.init(id: UUID(),
			  name: "Air Bud",
			  age: "6 months",
			  breed: "Golden Retriever",
			  weight: "30 lbs",
			  temperment: "Calm",
			  specialNeeds: "n/a",
			  lastVaccinated: "Dec 12, 2023"
//			  avatar: URL(string: Constants.pic),
//			  header: URL(string: Constants.cover)
			)
	}

	static func placeholders() -> [PetProfile] {
		[.placeholder(), .placeholder(), .placeholder()]
	}
}

struct CreatePetProfileData: Codable, Equatable {
	var name: String?
	var user_id: UUID
	var age: String?
	var breed: String?
	var weight: String?
	var temperment: String?
	var specialNeeds: String?
	var lastVaccinated: String?
}

final class ProfileDTO: Codable, Sendable {

	let name: String
	let age: String
	let breed: String
	let weight: String
	let temperment: String
	let specialNeeds: String
	let lastVaccinated: String
	let customerId: String

	enum CodingKeys: String, CodingKey {
		case name, age, breed, weight, temperment, specialNeeds, lastVaccinated, customerId
	}

	init(name: String,
		age: String,
		breed: String,
		weight: String,
		temperment: String,
		specialNeeds: String,
		lastVaccinated: String,
		customerId: String)
	{
		self.name = name
		self.age = age
		self.breed = breed
		self.weight = weight
		self.temperment = temperment
		self.specialNeeds = specialNeeds
		self.lastVaccinated = lastVaccinated
		self.customerId = customerId
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(String.self, forKey: .name)
		age = try container.decode(String.self, forKey: .age)
		breed = try container.decode(String.self, forKey: .breed)
		weight = try container.decode(String.self, forKey: .weight)
		temperment = try container.decode(String.self, forKey: .temperment)
		specialNeeds = try container.decode(String.self, forKey: .specialNeeds)
		lastVaccinated = try container.decode(String.self, forKey: .lastVaccinated)
		customerId = try container.decode(String.self, forKey: .customerId)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(age, forKey: .age)
		try container.encode(breed, forKey: .breed)
		try container.encode(weight, forKey: .weight)
		try container.encode(temperment, forKey: .temperment)
		try container.encode(specialNeeds, forKey: .specialNeeds)
		try container.encode(lastVaccinated, forKey: .lastVaccinated)
		try container.encode(customerId, forKey: .customerId)
	}
}
