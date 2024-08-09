//
//  AppointmentRequest.swift
//  CollarandComb
//
//  Created by Joel Muflam on 9/2/23.
//

import Foundation

struct AppointmentRequest: Identifiable, Codable, Equatable {

	static func == (lhs: AppointmentRequest, rhs: AppointmentRequest) -> Bool {
			lhs.id == rhs.id
	}

	var id: UUID
	var user: User
	var petProfiles: [PetProfile]?

	init(id: UUID, user: User, petProfiles: [PetProfile]?) {
		self.id = id
		self.user = user
		self.petProfiles = petProfiles
	}
}


struct CreateAppointmentRequest: Identifiable, Codable{

	var id: UUID?
	var userID: UUID
	var petProfiles: [PetProfile]?

	init(id: UUID?, userID: UUID, petProfiles: [PetProfile]?) {
		self.id = id
		self.userID = userID
		self.petProfiles = petProfiles
	}
}
