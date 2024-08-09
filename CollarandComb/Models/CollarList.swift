//
//  List.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

struct CollarList: Codable, Identifiable, Equatable, Hashable {
	let id: String
	let title: String
	let repliesPolicy: RepliesPolicy?
	let exclusive: Bool?

	enum RepliesPolicy: String, Sendable, Codable, CaseIterable, Identifiable {
		var id: String {
			rawValue
		}

		case followed, list, none
	}

	init(id: String, title: String, repliesPolicy: RepliesPolicy? = nil, exclusive: Bool? = nil) {
		self.id = id
		self.title = title
		self.repliesPolicy = repliesPolicy
		self.exclusive = exclusive
	}
}

extension CollarList: Sendable {}

