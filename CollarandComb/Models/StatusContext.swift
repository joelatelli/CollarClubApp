//
//  StatusContext.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

struct ProductContext: Decodable {
  public let ancestors: [Product]
  public let descendants: [Product]

  public static func empty() -> ProductContext {
	.init(ancestors: [], descendants: [])
  }
}

extension ProductContext: Sendable {}

