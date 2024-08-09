//
//  Device.swift
//  CollarandComb
//
//  Created by Joel Muflam on 9/6/23.
//

import Foundation

struct UpdateDevice: Codable {
	let id: UUID?
	let pushToken: String?
	let system: Device.System
	let osVersion: String

	init(id: UUID? = nil, pushToken: String? = nil, system: Device.System, osVersion: String) {
		self.id = id
		self.pushToken = pushToken
		self.system = system
		self.osVersion = osVersion
	}
}

struct Device: Codable {
	enum System: String, Codable {
		case iOS
		case android
	}

	let id: UUID
	let system: System
	var osVersion: String
	var pushToken: String?

	init(id: UUID, system: System, osVersion: String, pushToken: String?) {
		self.id = id
		self.system = system
		self.osVersion = osVersion
		self.pushToken = pushToken
	}
}
