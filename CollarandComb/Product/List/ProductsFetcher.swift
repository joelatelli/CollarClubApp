//
//  ProductsFetcher.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Combine
import Observation
import SwiftUI

enum ProductsState {
	enum PagingState {
		case hasNextPage, loadingNextPage, none
	}

	case loading
	case display(products: [Product], nextPageState: ProductsState.PagingState)
	case error(error: Error)
}

@MainActor
protocol ProductsFetcher {
	var productsState: ProductsState { get }
	func fetchNewestProducts(pullToRefresh: Bool) async
	func fetchNextPage() async
	func productDidAppear(product: Product)
	func productDidDisappear(product: Product)
}
