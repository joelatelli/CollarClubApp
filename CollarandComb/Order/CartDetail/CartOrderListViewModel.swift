//
//  OrderViewModel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import Foundation
import Network
import SwiftUI

@MainActor
@Observable class CartOrderListViewModel {
	var orderId: String?
	var remoteOrderURL: URL?

	var client: Client?
	var routerPath: RouterPath?

	var productOrderState: ProductOrderState = .loading

	var title: LocalizedStringKey = ""
	var scrollToId: String?

	@ObservationIgnored
	var indentationLevelPreviousCache: [String: UInt] = [:]

	init(orderId: String) {
		productOrderState = .loading
		self.orderId = orderId
		remoteOrderURL = nil
	}

	init(products: [ProductOrder]) {
		productOrderState = .display(products: products, nextPageState: .none)
		orderId = nil
		remoteOrderURL = nil
	}

	func fetch() async -> Bool {
		if orderId != nil {
			await fetchStatusDetail(animate: false)
			return true
		} else if remoteOrderURL != nil {
			return await fetchRemoteStatus()
		}
		return false
	}

	private func fetchRemoteStatus() async -> Bool {
		guard let client, let remoteOrderURL else { return false }
		let results: SearchResults? = try? await client.get(endpoint: Search.search(query: remoteOrderURL.absoluteString,
																					type: "statuses",
																					offset: nil,
																					following: nil),
															forceVersion: .v2)
		if let productId = results?.statuses.first?.id {
			self.orderId = orderId
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
		guard let client, let orderId else { return }
//		do {
//			let data = try await fetchContextData(client: client, statusId: orderId)
//			title = "\(data.product.title)"
//			var statuses = data.context.ancestors
//			statuses.append(data.product)
//			statuses.append(contentsOf: data.context.descendants)
//			cacheReplyTopPrevious(statuses: statuses)
//			ProductDataControllerProvider.shared.updateDataControllers(for: statuses, client: client)
//
//			if animate {
//				withAnimation {
//					state = .display(products: statuses)
//				}
//			} else {
//				state = .display(products: statuses)
//				//				scrollToId = data.status.id + (data.status.editedAt?.asDate.description ?? "")
//			}
//		} catch {
//			if let error = error as? ServerError, error.httpCode == 404 {
//				_ = routerPath?.path.popLast()
//			} else {
//				state = .error(error: error)
//			}
//		}
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

	func sendOrder(order: OrderDTO) {
		NetWorkManager.makePostRequestWithoutReturn(sending: order,
													path: "orders/",
													authType: .bearer
		) { result in
			switch result {
			case .success:
				print("Order Successful ---")
			case .failure(let error):
				print("")
			}
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

extension CartOrderListViewModel: ProductOrderFetcher {
	
	func productDidAppear(product: ProductOrder) {
		print(product.product.name)
	}
	
	func productDidDisappear(product: ProductOrder) {
		print(product.product.name)
	}
	

	func fetchNewestProducts(pullToRefresh: Bool) async {

	}
	
	func fetchNextPage() async {

	}
	
	func productDidAppear(product status: Product) {
//		pendingStatusesObserver.removeStatus(status: status)
//		visibileStatuses.insert(status, at: 0)
//
//		if let client, timeline.supportNewestPagination {
//			Task {
//				await cache.setLatestSeenStatuses(visibileStatuses, for: client, filter: timeline.id)
//			}
//		}
	}

	func productDidDisappear(product: Product) {
//		visibileStatuses.removeAll(where: { $0.id == product.id })
	}
}


