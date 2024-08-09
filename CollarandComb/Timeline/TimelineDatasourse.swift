//
//  TimelineDatasourse.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

actor TimelineDatasource {
  private var products: [Product] = []

  var isEmpty: Bool {
	  products.isEmpty
  }

  func get() -> [Product] {
	  products
  }

  func getFiltered() async -> [Product] {
//	let contentFilter = TimelineContentFilter.shared
//	let showReplies = await contentFilter.showReplies
//	let showBoosts = await contentFilter.showBoosts
//	let showThreads = await contentFilter.showThreads
//	let showQuotePosts = await contentFilter.showQuotePosts
	return products.filter { status in
//	  if status.isHidden ||
//		  !showReplies && status.inReplyToId != nil && status.inReplyToAccountId != status.account.id  ||
//		  !showBoosts && status.reblog != nil ||
//		  !showThreads && status.inReplyToAccountId == status.account.id ||
//		  !showQuotePosts && !status.content.statusesURLs.isEmpty {
//		return false
//	  }
	  return true
	}
  }

  func count() -> Int {
	  products.count
  }

  func reset() {
	  products = []
  }

  func indexOf(statusId: String) -> Int? {
	  products.firstIndex(where: { $0.id!.uuidString == statusId })
  }

  func contains(statusId: String) -> Bool {
	  products.contains(where: { $0.id!.uuidString == statusId })
  }

  func set(_ products: [Product]) {
	self.products = products
  }

  func append(_ product: Product) {
	  products.append(product)
  }

  func append(contentOf: [Product]) {
	  products.append(contentsOf: contentOf)
  }

  func insert(_ product: Product, at: Int) {
	  products.insert(product, at: at)
  }

  func insert(contentOf: [Product], at: Int) {
	  products.insert(contentsOf: contentOf, at: at)
  }

  func replace(_ product: Product, at: Int) {
	  products[at] = product
  }

  func remove(_ productId: String) {
	  products.removeAll(where: { $0.id!.uuidString == productId })
  }
}

