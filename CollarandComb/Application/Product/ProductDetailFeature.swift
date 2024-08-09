//
//  ProductDetailFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/30/23.
//

import Foundation
import ComposableArchitecture

struct ProductDetailFeature: ReducerProtocol {

	struct State: Equatable, Identifiable {

		init(product: Product2) {
			self.product = product
			self.id = product.id
		}

		let id: UUID
		public var product: Product2
		var addToCartState = AddToCartFeature.State()
		var count = 0
		var total: Float = 0
	}

	enum Action: Equatable {
		case addToCart(AddToCartFeature.Action)
		case increaseCounter
		case decreaseCounter
		case addFirstOption(String)
		case removeFirstOption(String)
		case addSecondOption(String)
		case removeSecondOption(String)
		case addThirdOption(String)
		case removeThirdOption(String)
		case favorite
		case unfavorite
	}

	@Dependency(\.productClient) private var productClient
	@Dependency(\.hudClient) private var hudClient
	@Dependency(\.openURL) private var openURL
	@Dependency(\.hapticClient) private var hapticClient
	@Dependency(\.logger) private var logger
	@Dependency(\.mainQueue) private var mainQueue

	var body: some ReducerProtocol<State, Action> {
		Scope(state: \.addToCartState, action: /ProductDetailFeature.Action.addToCart) {
			AddToCartFeature()
		}

		Reduce { state, action in
			switch action {
			case .addToCart(.increaseCounter):
				return .none

			case .addToCart(.decreaseCounter):
				state.addToCartState.count = max(0, state.addToCartState.count)
				return .none
			case .increaseCounter:
				state.count += 1
				state.total += state.product.price
				state.product.quantity += 1
				return .none

			case .decreaseCounter:

				state.count -= 1
				state.total -= state.product.price
				state.product.quantity -= 1

				return .none
			case .addFirstOption(let string):
				state.product.optionOne = string
				return .none
			case .removeFirstOption:
				state.product.optionOne = nil
				return .none
			case .addSecondOption(let string):
				state.product.optionTwo = string
				return .none
			case .removeSecondOption:
				state.product.optionTwo = nil
				return .none
			case .addThirdOption(let string):
				state.product.optionThree = string
				return .none
			case .removeThirdOption:
				state.product.optionThree = nil
				return .none
			case .favorite:
				productClient.favoriteProduct(state.product.id)
				hudClient.show(message: "\(state.product.title) has been added to your favorites")
				return .none
			case .unfavorite:
				productClient.unfavoriteProduct(state.product.id)
				hudClient.show(message: "\(state.product.title) has been removed from your favorites")
				return .none
			}
		}
	}
}

