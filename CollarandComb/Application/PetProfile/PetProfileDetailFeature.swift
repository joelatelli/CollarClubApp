//
//  PetProfileDetailFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/31/23.
//

import Foundation
import ComposableArchitecture

struct PetProfileDetailFeature: ReducerProtocol {

	struct State: Equatable, Identifiable {

		init(profile: PetProfile) {
			self.profile = profile
			self.id = profile.id ?? UUID()
			addSheetState = PetProfileSheetFeature.State(profile: profile)
		}

		var addSheetState = PetProfileSheetFeature.State(profile: nil)

		let id: UUID
		public var profile: PetProfile
		var count = 0
		var total: Float = 0
	}

	enum Action: Equatable {
		case favorite
		case unfavorite
		case deleteProfile
		case addPetProfileSheetAction(PetProfileSheetFeature.Action)
		case updateProfilePressed
	}

	@Dependency(\.productClient) private var productClient
	@Dependency(\.userClient) private var userClient
	@Dependency(\.hudClient) private var hudClient
	@Dependency(\.openURL) private var openURL
	@Dependency(\.hapticClient) private var hapticClient
	@Dependency(\.logger) private var logger
	@Dependency(\.mainQueue) private var mainQueue

	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .deleteProfile:
				userClient.deletePetProfile(state.id.uuidString)
				return .none
			case .favorite:
				return .none
			case .unfavorite:
				return .none
			case .addPetProfileSheetAction:
				return .none
			case .updateProfilePressed:
				return .none
			}
		}
		Scope(state: \.addSheetState, action: /Action.addPetProfileSheetAction) {
			PetProfileSheetFeature()
		}
	}
}

