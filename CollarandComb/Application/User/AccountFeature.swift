//
//  AccountFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import Foundation
import ComposableArchitecture


struct AccountFeature: ReducerProtocol {

	struct State: Equatable {
		var productList: IdentifiedArrayOf<ProductRowFeature.State> = []
		var savedProductList: IdentifiedArrayOf<ProductRowFeature.State> = []
		var orderProductList: IdentifiedArrayOf<ProductRowFeature.State> = []

		// Keep a status to prevent for not reloading when not needed
		var dataLoadingStatus = DataLoadingStatus.notStarted

		var isRefreshActionInProgress = false

		var user: User?

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
		case onAppear(String)
		case product(id: UUID, action: ProductRowFeature.Action)
		case productRowAction(UUID, ProductRowFeature.Action)
		case favoriteProductsFetched(
			Result<ResponseData<[Product]>, AppError>,
			WritableKeyPath<State, IdentifiedArrayOf<ProductRowFeature.State>>
		)
		case userInfoFetched(Result<ResponseData<User>, AppError>)
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
			case .onAppear(let uuid):
				guard state.user.isNil else { return .none }

				return .concatenate(
					productClient.fetchUserFavorites(uuid, state.limit ?? 15, state.page)
						.receive(on: mainQueue)
						.catchToEffect { .favoriteProductsFetched($0, \.savedProductList) }
				)
//				return productClient.fetchMeUser()
//							.receive(on: mainQueue)
//							.catchToEffect(Action.userInfoFetched)

			case .userInfoFetched(let result):
				switch result {
				case .success(let response):
					state.user = response.data

					return .concatenate(
						productClient.fetchUserFavorites(response.data.id!.uuidString, state.limit ?? 15, state.page)
							.receive(on: mainQueue)
							.catchToEffect { .favoriteProductsFetched($0, \.savedProductList) }
					)
				case .failure(let error):
					logger.error(
						"Failed to fetch User info: \(error)",
						context: [
//							"authorID": state.user.id.uuidString.lowercased()
						]
					)
					return .none
				}
			case .favoriteProductsFetched(let result, let keyPath):
				switch result {
				case .success(let response):
					let todoIDsList = state[keyPath: keyPath].map(\.id)
					let fetchedTodoIDsList = Array(response.data.map(\.id))

					guard todoIDsList != fetchedTodoIDsList else {
						return .none
					}

//					let pagProductRowStates = response.data.map { ProductRowFeature.State(product: $0) }.asIdentifiedArray
//					state.savedProductList.append(contentsOf: pagProductRowStates)
//
//					state.limit = response.limit
//					state.total = response.total
//					state.page += 1

					return .none

				case .failure(let error):
					hudClient.show(message: error.description)
					logger.error(
						"Failed to load manga list: \(error)",
						context: ["keyPath": "`\(keyPath.customDumpDescription)`"]
					)
					return hapticClient.generateNotificationFeedback(.error).fireAndForget()
				}
			case .product:
				return .none
			case .productRowAction:
				return .none
			}

		}
		.forEach(\.productList, action: /AccountFeature.Action.product(id:action:)) {
			ProductRowFeature()
		}
		.forEach(\.savedProductList, action: /AccountFeature.Action.productRowAction) {
			ProductRowFeature()
		}
	}
}


