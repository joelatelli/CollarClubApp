//
//  CartFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import Foundation
import ComposableArchitecture

struct CartFeature: ReducerProtocol {

	struct State: Equatable {
		var productList: IdentifiedArrayOf<ProductRowFeature.State> = []

		// Keep a status to prevent for not reloading when not needed
		var dataLoadingStatus = DataLoadingStatus.notStarted
	}


	enum Action: Equatable {
		case product
	}

	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {

			case .product:
				return .none
			}
		}
	}
}


