//
//  PetProfileRowFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/31/23.
//

import Foundation
import ComposableArchitecture

struct PetProfileRowFeature: ReducerProtocol {

	struct State: Equatable, Identifiable {

		init(profile: PetProfile) {
			profileDetailState = PetProfileDetailFeature.State(profile: profile)
			self.profile = profile
			self.id = profile.id ?? UUID()
		}

		let id: UUID
		let profile: PetProfile

		var profileDetailState: PetProfileDetailFeature.State?

		@BindableState var navigationLinkActive = false

		@BindableState var sheetLinkActive = false

	}

	enum Action: Equatable, BindableAction {
		case binding(BindingAction<State>)
		case profileDetailAction(PetProfileDetailFeature.Action)
	}

	var body: some ReducerProtocol<State, Action> {
		BindingReducer()

		Reduce { state, action in
			switch action {
			case .binding:
				return .none
			case .profileDetailAction:
				return .none
			}
		}
		.ifLet(\.profileDetailState, action: /Action.profileDetailAction) {
			PetProfileDetailFeature()
		}
	}
}

