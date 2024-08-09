//
//  PetProfileSheetFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/31/23.
//

import Foundation
import ComposableArchitecture

struct PetProfileSheetFeature: ReducerProtocol {
	struct State: Equatable {

		init(profile: PetProfile?) {
			self.profile = profile
		}

		let profile: PetProfile?

		@BindableState var isAddMediaSheetActive = false

	}

	enum Action: Equatable {
		case fetchFilterTagsIfNeeded
		case addPetProfile(CreatePetProfileData)
		case updatePetProfile(CreatePetProfileData)
	}

	@Dependency(\.hapticClient) private var hapticClient
	@Dependency(\.logger) private var logger
	@Dependency(\.mainQueue) private var mainQueue
	@Dependency(\.hudClient) private var hudClient
	@Dependency(\.userClient) private var userClient


	// swiftlint:disable:next cyclomatic_complexity function_body_length
	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .updatePetProfile(let profile):
				userClient.updatePetProfile(profile, state.profile!.id!.uuidString)
				return .none
			case .addPetProfile(let profile):
				userClient.createPetProfile(profile)
				return .none
			case .fetchFilterTagsIfNeeded:
				return .none

			}
		}
	}
}



