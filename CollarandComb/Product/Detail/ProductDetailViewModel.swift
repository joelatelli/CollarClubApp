//
//  ProductDetailViewModel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import Network
import SwiftUI

@MainActor
@Observable class ProductDetailViewModel {
	var productId: String?
	var product: Product?
	var remoteProductURL: URL?

	var client: Client?
	var routerPath: RouterPath?

	var isFavorited = false

	enum State {
		case loading, display(products: [Product]), error(error: Error)
	}

	var state: State = .loading
	var title: LocalizedStringKey = ""
	var scrollToId: String?

	var accountId: String?

	@ObservationIgnored
	var indentationLevelPreviousCache: [String: UInt] = [:]

	init(productId: String) {
		state = .loading
		self.productId = productId
		remoteProductURL = nil
		product = nil
	}

	init(product: Product) {
		state = .display(products: [product])
		self.product = product
		title = "\(product.name)"
		productId = product.id!.uuidString
		remoteProductURL = nil
	}

	init(remoteStatusURL: URL) {
		state = .loading
		self.remoteProductURL = remoteProductURL
		productId = nil
		product = nil
	}

	func fetch() async -> Bool {
		if productId != nil {
			await fetchStatusDetail(animate: false)
			return true
		} else if remoteProductURL != nil {
			return await fetchRemoteStatus()
		}
		return false
	}

	private func fetchRemoteStatus() async -> Bool {
		guard let client, let remoteProductURL else { return false }
		let results: SearchResults? = try? await client.get(endpoint: Search.search(query: remoteProductURL.absoluteString,
																					type: "statuses",
																					offset: nil,
																					following: nil),
															forceVersion: .v2)
		if let productId = results?.statuses.first?.id {
			self.productId = productId.uuidString
			await fetchStatusDetail(animate: false)
			return true
		} else {
			return false
		}
	}

	struct ContextData {
		let product: Product
		let context: ProductContext
	}

	private func fetchStatusDetail(animate: Bool) async {
		guard let client, let productId else { return }
		do {
			let data = try await fetchContextData(client: client, statusId: productId)
			title = "\(data.product.name)"
			var statuses = data.context.ancestors
			statuses.append(data.product)
			statuses.append(contentsOf: data.context.descendants)
			cacheReplyTopPrevious(statuses: statuses)
			ProductDataControllerProvider.shared.updateDataControllers(for: statuses, client: client)

			if animate {
				withAnimation {
					state = .display(products: statuses)
				}
			} else {
				state = .display(products: statuses)
//				scrollToId = data.status.id + (data.status.editedAt?.asDate.description ?? "")
			}
		} catch {
			if let error = error as? ServerError, error.httpCode == 404 {
				_ = routerPath?.path.popLast()
			} else {
				state = .error(error: error)
			}
		}
	}

	// Favorite Product
	func favorite() async {
		guard ((client?.isAuth) != nil) else { return }
		isFavorited = true
		let data = FavoriteDTO(productId: productId!, customerId: accountId ?? "fbb3940a-91a1-46e4-9a4a-f8cdb170cc04")
		do {
			NetWorkManager.makePostRequestWithoutReturn(sending: data,
														path: "favorite-product",
														authType: .bearer
			) { result in
				switch result {
				case .success:
					print("Favorited PRODUCT")
//					self.isSaving = false
				case .failure(let error):
					print("Failed Favorited PRODUCT")
//					self.saveError = true
				}
			}
//			let favorite: FavoriteDTO = try await client!.post(endpoint: Products.bookmark(json: data))
		} catch {
			isFavorited = false
		}
	}

	private func fetchContextData(client: Client, statusId: String) async throws -> ContextData {
		async let status: Product = client.get(endpoint: Products.status(id: statusId))
		async let context: ProductContext = client.get(endpoint: Products.context(id: statusId))
		return try await .init(product: status, context: context)
	}

	private func cacheReplyTopPrevious(statuses: [Product]) {
		indentationLevelPreviousCache = [:]
		for status in statuses {
			indentationLevelPreviousCache[status.id!.uuidString] = 0
		}
	}

	func handleEvent(event: any StreamEvent, currentAccount: Account?) {
//		Task {
//			if let event = event as? StreamEventUpdate,
//			   event.status.account.id == currentAccount?.id
//			{
//				await fetchStatusDetail(animate: true)
//			} else if let event = event as? StreamEventStatusUpdate,
//					  event.status.account.id == currentAccount?.id
//			{
//				await fetchStatusDetail(animate: true)
//			} else if event is StreamEventDelete {
//				await fetchStatusDetail(animate: true)
//			}
//		}
	}

	func getIndentationLevel(id: String, maxIndent: UInt) -> (indentationLevel: UInt, extraInset: Double) {
		let level = min(indentationLevelPreviousCache[id] ?? 0, maxIndent)

		let barSize = Double(level) * 2
		let spaceBetween = (Double(level) - 1) * 3
		let size = barSize + spaceBetween + 8

		return (level, size)
	}
}

