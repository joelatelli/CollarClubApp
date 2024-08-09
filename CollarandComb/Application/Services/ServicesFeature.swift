//
//  ServicesFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import Foundation
import ComposableArchitecture


struct ServicesFeature: ReducerProtocol {

	struct State: Equatable {
		var productList: IdentifiedArrayOf<ProductRowFeature.State> = []
		var profileList: IdentifiedArrayOf<PetProfileRowFeature.State> = []

		var addSheetState = PetProfileSheetFeature.State(profile: nil)

		// Keep a status to prevent for not reloading when not needed
		var dataLoadingStatus = DataLoadingStatus.notStarted

		public var answers = CreateQuestionnaire()

		@BindableState var sheetLinkActive = false

		var lastRefreshDate: Date?

		public var limit: Int?
		public var total: Int?
		public var page: Int = 1

		var hasMoreData: Bool {
		   guard let limit = limit, let total = total else {
			   return true
		   }
		   return profileList.count < total && profileList.count < limit * page
		}
	}

	@Dependency(\.userClient) private var userClient
	@Dependency(\.mainQueue) private var mainQueue
	@Dependency(\.hudClient) private var hudClient
	@Dependency(\.openURL) private var openURL
	@Dependency(\.hapticClient) private var hapticClient
	@Dependency(\.logger) private var logger

	enum Action: Equatable, BindableAction {
		case onAppear
		case titleTextFieldChanged(String)
		case addPetProfile(CreatePetProfileData)
		case profileRowAction(UUID, PetProfileRowFeature.Action)
		case profileListFetched(
			Result<ResponseData<[PetProfile]>, AppError>,
			WritableKeyPath<State, IdentifiedArrayOf<PetProfileRowFeature.State>>
		)
		case binding(BindingAction<State>)
		case addPetProfileSheetAction(PetProfileSheetFeature.Action)
	}

	var body: some ReducerProtocol<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .onAppear:
				guard state.profileList.isEmpty else { return .none }

				return .concatenate(
					userClient.getProfiles(state.limit ?? 10, state.page)
						.receive(on: mainQueue)
						.catchToEffect { .profileListFetched($0, \.profileList) }
				)
			case .profileListFetched(let result, let keyPath):
				switch result {
				case .success(let response):
					let todoIDsList = state[keyPath: keyPath].map(\.id)
					let fetchedTodoIDsList = Array(response.data.map(\.id))

					guard todoIDsList != fetchedTodoIDsList else {
						return .none
					}

					let pagProductRowStates = response.data.map { PetProfileRowFeature.State(profile: $0) }.asIdentifiedArray
					state.profileList.append(contentsOf: pagProductRowStates)

					state.limit = response.limit
					state.total = response.total
					state.page += 1

					return .none

				case .failure(let error):
					hudClient.show(message: error.description)
					state.lastRefreshDate = nil
					logger.error(
						"Failed to load pet profile list: \(error)",
						context: ["keyPath": "`\(keyPath.customDumpDescription)`"]
					)
					return hapticClient.generateNotificationFeedback(.error).fireAndForget()
				}
			case .addPetProfile(let profile):
				userClient.createPetProfile(profile)
				return .none
			case .profileRowAction:
				return .none
			case .titleTextFieldChanged(let text):
				state.answers.name = text
				return .none
			case .binding:
				return .none
			case .addPetProfileSheetAction:
				return .none
			}
		}
		.forEach(\.profileList, action: /ServicesFeature.Action.profileRowAction) {
			PetProfileRowFeature()
		}
		Scope(state: \.addSheetState, action: /Action.addPetProfileSheetAction) {
			PetProfileSheetFeature()
		}
	}
}
