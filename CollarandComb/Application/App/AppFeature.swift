//
//  AppFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import ComposableArchitecture

struct AppFeature: ReducerProtocol {
	struct State: Equatable {
		var rootState: MainFeature.State
	}

	enum Action {
		case initApp
		case rootAction(MainFeature.Action)
	}

	var body: some ReducerProtocol<State, Action> {
		Reduce { _, action in
			switch action {
			case .initApp:

				return .none

			case .rootAction:
				return .none
			}
		}
		Scope(state: \.rootState, action: /Action.rootAction) {
			MainFeature()
		}
	}
}


