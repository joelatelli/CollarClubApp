//
//  OrderDataController.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import Foundation
import Network
import Observation
import SwiftUI

@MainActor
protocol OrderDataControlling {
//	var isBookmarked: Bool { get set }

	func toggleBookmark(remoteStatus: String?) async
}

@MainActor
final class OrderDataControllerProvider {
	static let shared = OrderDataControllerProvider()

	private var cache: NSMutableDictionary = [:]

	private struct CacheKey: Hashable {
		let statusId: String
		let client: Client
	}

	func dataController(for order: any AnyOrder, client: Client) -> OrderDataController {
		let key = CacheKey(statusId: order.id!.uuidString, client: client)
		if let controller = cache[key] as? OrderDataController {
			return controller
		}
		let controller = OrderDataController(order: order, client: client)
		cache[key] = controller
		return controller
	}

	func updateDataControllers(for orders: [Order], client: Client) {
		for order in orders {
			let realOrder: AnyOrder = order
			let controller = dataController(for: realOrder, client: client)
			controller.updateFrom(order: realOrder)
		}
	}
}

@MainActor
@Observable final class OrderDataController: OrderDataControlling {
	private let order: AnyOrder
	private let client: Client

//	var isBookmarked: Bool
//	var title: String
//	var desc: String

	init(order: AnyOrder, client: Client) {
		self.order = order
		self.client = client

//		isBookmarked = product.bookmarked == true

//		title = product.title
//		desc = product.desc
	}

	func updateFrom(order: AnyOrder) {
//		isBookmarked = product.bookmarked == true
//
//		desc = product.title
	}

	func toggleBookmark(remoteStatus: String?) async {
//		guard client.isAuth else { return }
//		isBookmarked.toggle()
//		let id = product.id.uuidString
//		let endpoint = isBookmarked ? Products.bookmark(id: id) : Products.unbookmark(id: id)
//		do {
//			let status: Product = try await client.post(endpoint: endpoint)
//			updateFrom(product: status)
//		} catch {
//			isBookmarked.toggle()
//		}
	}
}


