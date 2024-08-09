//
//  HomeFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation
import ComposableArchitecture

struct HomeFeature {

	// define any effects
	var fetchProducts: @Sendable () async throws -> [Product]
	var sendOrder: @Sendable ([Product]) async throws -> String
}

extension HomeFeature: ReducerProtocol {

	struct State: Equatable {
		var productList: IdentifiedArrayOf<ProductRowFeature.State> = []

		// Keep a status to prevent for not reloading when not needed
		var dataLoadingStatus = DataLoadingStatus.notStarted
	}


	enum Action: Equatable {
		case fetchProducts
		case fetchProductResponse(TaskResult<[Product]>)
		case product(id: UUID, action: ProductRowFeature.Action)
	}

	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in

			switch action {

			case .fetchProducts:
				// check if data is not alreadyloading or loaded
				guard state.dataLoadingStatus != .loading || state.dataLoadingStatus != .success else { return .none }

				// set loading
				state.dataLoadingStatus = .loading

				// send effect and return anotion action
				return .task {
					await .fetchProductResponse(
						TaskResult {try await fetchProducts() }
					)
				}
			case .fetchProductResponse(.success(let products)):
				state.dataLoadingStatus = .success

//				state.productList = IdentifiedArrayOf(
//					uniqueElements: products.map {
//						ProductRowFeature.State(
//							product: $0
//						)
//					}
//				)

				return .none

			case .fetchProductResponse(.failure(let error)):

				print(error)
				print("Error getting products, try again later.")
				// received handle en describe here how to handle it.
				state.dataLoadingStatus = .error
				return .none

			case .product:
				return .none
			}

		}
		.forEach(\.productList, action: /HomeFeature.Action.product(id:action:)) {
			ProductRowFeature()
		}
	}
}

