//
//  PlusMinusStore.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation
import ComposableArchitecture

struct AddToCartFeature: ReducerProtocol {

	struct State: Equatable {
		var count = 0
	}

	enum Action {
		case increaseCounter
		case decreaseCounter
	}

	struct Environment {}



	func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
		switch action {
		case .increaseCounter:
			state.count += 1
			return .none

		case .decreaseCounter:

			state.count -= 1
			return .none
		}
	}
}
