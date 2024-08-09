//
//  ProductListStore.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation
import ComposableArchitecture

struct ProductListFeature: ReducerProtocol {

	struct State: Equatable {
		var productList: IdentifiedArrayOf<ProductRowFeature.State> = []
		var seasonalList: IdentifiedArrayOf<ProductRowFeature.State> = []
		var ourFavoritesList: IdentifiedArrayOf<ProductRowFeature.State> = []

		// Keep a status to prevent for not reloading when not needed
		var dataLoadingStatus = DataLoadingStatus.notStarted

		var lastRefreshDate: Date?

		var seasonalTabName: String?

		var isRefreshActionInProgress = false

		public var limit: Int?
		public var total: Int?
		public var page: Int = 1

		var hasMoreData: Bool {
		   guard let limit = limit, let total = total else {
			   return true
		   }
		   return productList.count < total && productList.count < limit * page
		}
	}


	enum Action: Equatable {
		case onAppear
		case productRowAction(UUID, ProductRowFeature.Action)
		case productListFetched(
			Result<ResponseData<[Product]>, AppError>,
			WritableKeyPath<State, IdentifiedArrayOf<ProductRowFeature.State>>
		)
	}

	@Dependency(\.productClient) private var productClient
	@Dependency(\.mainQueue) private var mainQueue
	@Dependency(\.hudClient) private var hudClient
	@Dependency(\.openURL) private var openURL
	@Dependency(\.hapticClient) private var hapticClient
	@Dependency(\.logger) private var logger

	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in

			switch action {
			case .onAppear:
				guard state.productList.isEmpty else { return .none }

//				let pagProductRowStates = Product.sample.map { ProductRowFeature.State(product: $0) }.asIdentifiedArray
//				state.productList.append(contentsOf: pagProductRowStates)
//				return .none
				return .concatenate(
					productClient.fetchProducts(state.limit ?? 10, state.page)
						.receive(on: mainQueue)
						.catchToEffect { .productListFetched($0, \.productList) }

				)
			case .productListFetched(let result, let keyPath):
				switch result {
				case .success(let response):
					let todoIDsList = state[keyPath: keyPath].map(\.id)
					let fetchedTodoIDsList = Array(response.data.map(\.id))

					guard todoIDsList != fetchedTodoIDsList else {
						return .none
					}

//					let pagProductRowStates = response.data.map { ProductRowFeature.State(product: $0) }.asIdentifiedArray
//					state.productList.append(contentsOf: pagProductRowStates)
//
//					state.limit = response.limit
//					state.total = response.total
					state.page += 1

					return .none

				case .failure(let error):
					hudClient.show(message: error.description)
					state.lastRefreshDate = nil
					logger.error(
						"Failed to load manga list: \(error)",
						context: ["keyPath": "`\(keyPath.customDumpDescription)`"]
					)
					return hapticClient.generateNotificationFeedback(.error).fireAndForget()
				}
			case .productRowAction:
				return .none
			}

		}
		.forEach(\.productList, action: /ProductListFeature.Action.productRowAction) {
			ProductRowFeature()
		}
	}
}

