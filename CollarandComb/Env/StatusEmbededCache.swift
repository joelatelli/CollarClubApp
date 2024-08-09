//
//  StatusEmbededCache.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import SwiftUI

@MainActor
class StatusEmbedCache {
  static let shared = StatusEmbedCache()

  private var cache: [URL: Product] = [:]

  var badProductsURLs = Set<URL>()

  private init() {}

  func set(url: URL, product: Product) {
	cache[url] = product
  }

  func get(url: URL) -> Product? {
	cache[url]
  }
}

