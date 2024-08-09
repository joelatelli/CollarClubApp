//
//  EventRowFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import Foundation
import ComposableArchitecture

struct EventRowFeature: ReducerProtocol {

	struct State: Equatable, Identifiable {

		init(event: Event) {
			self.event = event
			self.id = event.id ?? UUID()
		}

		let id: UUID
		let event: Event

		@BindableState var navigationLinkActive = false

	}

	enum Action: Equatable, BindableAction {
		case binding(BindingAction<State>)
		case addToCart(AddToCartFeature.Action)
		case productDetailAction(ProductDetailFeature.Action)
	}

	var body: some ReducerProtocol<State, Action> {
		BindingReducer()

		Reduce { state, action in
			switch action {
			case .addToCart(.increaseCounter):
				return .none

			case .addToCart(.decreaseCounter):
				return .none
			case .binding:
				return .none
			case .productDetailAction:
				return .none
			}
		}
	}
}

