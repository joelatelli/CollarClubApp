//
//  Token.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/14/23.
//

import Foundation

/// #The Token used to authorize requests from the application.
struct Token: Codable {

	var id: UUID?
	var value: String

	init(value: String) {
		self.value = value
	}
}

