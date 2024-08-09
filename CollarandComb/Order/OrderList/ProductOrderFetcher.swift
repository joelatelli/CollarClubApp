//
//  ProductOrderFetcher.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/17/24.
//

import Foundation
import Combine
import Observation
import SwiftUI

enum ProductOrderState {
	enum PagingState {
		case hasNextPage, loadingNextPage, none
	}

	case loading
	case display(products: [ProductOrder], nextPageState: ProductOrderState.PagingState)
	case error(error: Error)
}

@MainActor
protocol ProductOrderFetcher {
	var productOrderState: ProductOrderState { get }
	func fetchNewestProducts(pullToRefresh: Bool) async
	func fetchNextPage() async
	func productDidAppear(product: ProductOrder)
	func productDidDisappear(product: ProductOrder)
}
