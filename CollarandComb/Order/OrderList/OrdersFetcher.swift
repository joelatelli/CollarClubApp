//
//  OrdersFetcher.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import Combine
import Observation
import SwiftUI

enum OrdersState {
	enum PagingState {
		case hasNextPage, loadingNextPage, none
	}

	case loading
	case display(orders: [Order], nextPageState: OrdersState.PagingState)
	case error(error: Error)
}

@MainActor
protocol OrdersFetcher {
	var ordersState: OrdersState { get }
//	func fetchNewestProducts(pullToRefresh: Bool) async
//	func fetchNextPage() async
	func orderDidAppear(order: Order)
	func orderDidDisappear(order: Order)
}

