//
//  StatusDataController.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import Network
import Observation
import SwiftUI

@MainActor
protocol ProductDataControlling {
	var isBookmarked: Bool { get set }

	func toggleBookmark(remoteStatus: String?) async
}

@MainActor
final class ProductDataControllerProvider {
	static let shared = ProductDataControllerProvider()

	private var cache: NSMutableDictionary = [:]

	private struct CacheKey: Hashable {
		let statusId: String
		let client: Client
	}

	func dataController(for status: any AnyProduct, client: Client) -> ProductDataController {
		let key = CacheKey(statusId: status.id!.uuidString, client: client)
		if let controller = cache[key] as? ProductDataController {
			return controller
		}
		let controller = ProductDataController(product: status, client: client)
		cache[key] = controller
		return controller
	}

	func updateDataControllers(for statuses: [Product], client: Client) {
		for status in statuses {
			let realStatus: AnyProduct = status
			let controller = dataController(for: realStatus, client: client)
			controller.updateFrom(product: realStatus)
		}
	}
}

@MainActor
@Observable final class ProductDataController: ProductDataControlling {
	private let product: AnyProduct
	private let client: Client

	var isBookmarked: Bool
	var title: String
	var desc: String

	init(product: AnyProduct, client: Client) {
		self.product = product
		self.client = client

		isBookmarked = true
//		isBookmarked = product.bookmarked == true

		title = product.name
		desc = product.desc
	}

	func updateFrom(product: AnyProduct) {
		isBookmarked = true
//		isBookmarked = product.bookmarked == true

		desc = product.name
	}

	func toggleBookmark(remoteStatus: String?) async {
		guard client.isAuth else { return }
		isBookmarked.toggle()
		let id = product.id!.uuidString
		let endpoint = isBookmarked ? Products.bookmark(json: FavoriteDTO(productId: id, customerId: "fbb3940a-91a1-46e4-9a4a-f8cdb170cc04")) : Products.unbookmark(id: id)
		do {
			let status: Product = try await client.post(endpoint: endpoint)
			updateFrom(product: status)
		} catch {
			isBookmarked.toggle()
		}
	}
}

