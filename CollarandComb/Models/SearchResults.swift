//
//  SearchResults.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

struct SearchResults: Decodable {
  enum CodingKeys: String, CodingKey {
	case accounts, statuses, hashtags
  }

  let accounts: [Account]
//  var relationships: [Relationship] = []
  let statuses: [Product]
  let hashtags: [Tag]

  var isEmpty: Bool {
	accounts.isEmpty && statuses.isEmpty && hashtags.isEmpty
  }
}

extension SearchResults: Sendable {}

