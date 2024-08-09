//
//  EventsFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import Foundation
import ComposableArchitecture

struct EventsFeature {

	// define any effects
	var fetchEvents: @Sendable () async throws -> [Event]
	var sendOrder: @Sendable ([Event]) async throws -> String
}

extension EventsFeature: ReducerProtocol {

	struct State: Equatable {
		var eventList: IdentifiedArrayOf<EventRowFeature.State> = []

		// Keep a status to prevent for not reloading when not needed
		var dataLoadingStatus = DataLoadingStatus.notStarted
	}


	enum Action: Equatable {
		case fetchProducts
		case fetchProductResponse(TaskResult<[Event]>)
		case event(id: UUID, action: EventRowFeature.Action)
	}

	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in

			switch action {

			case .fetchProducts:
				// check if data is not alreadyloading or loaded
				guard state.dataLoadingStatus != .loading || state.dataLoadingStatus != .success else { return .none }

				// set loading
				state.dataLoadingStatus = .loading

				// send effect and return anotion action
				return .task {
					await .fetchProductResponse(
						TaskResult {try await fetchEvents() }
					)
				}
			case .fetchProductResponse(.success(let products)):
				state.dataLoadingStatus = .success

				state.eventList = IdentifiedArrayOf(
					uniqueElements: products.map {
						EventRowFeature.State(
							event: $0
						)
					}
				)

				return .none

			case .fetchProductResponse(.failure(let error)):

				print(error)
				print("Error getting products, try again later.")
				// received handle en describe here how to handle it.
				state.dataLoadingStatus = .error
				return .none

			case .event:
				return .none
			}

		}
		.forEach(\.eventList, action: /EventsFeature.Action.event(id:action:)) {
			EventRowFeature()
		}
	}
}

