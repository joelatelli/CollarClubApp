//
//  ProductFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation
import ComposableArchitecture

struct ProductRowFeature: ReducerProtocol {

	struct State: Equatable, Identifiable {

		init(product: Product2) {
			productDetailState = ProductDetailFeature.State(product: product)
			self.product = product
			self.id = product.id
		}
		
		let id: UUID
		let product: Product2
		var addToCartState = AddToCartFeature.State()

		var productDetailState: ProductDetailFeature.State?

		@BindableState var navigationLinkActive = false

		var count: Int {
			get { addToCartState.count }
			set { addToCartState.count = newValue }
		}
	}

	enum Action: Equatable, BindableAction {
		case binding(BindingAction<State>)
		case addToCart(AddToCartFeature.Action)
		case productDetailAction(ProductDetailFeature.Action)
	}

	var body: some ReducerProtocol<State, Action> {
		BindingReducer()

		Scope(state: \.addToCartState, action: /ProductRowFeature.Action.addToCart) {
			AddToCartFeature()
		}

		Reduce { state, action in
			switch action {
			case .addToCart(.increaseCounter):
				return .none

			case .addToCart(.decreaseCounter):
				state.addToCartState.count = max(0, state.addToCartState.count)
				return .none
			case .binding:
				return .none
			case .productDetailAction:
				return .none
			}
		}
		.ifLet(\.productDetailState, action: /Action.productDetailAction) {
			ProductDetailFeature()
		}
	}
}
