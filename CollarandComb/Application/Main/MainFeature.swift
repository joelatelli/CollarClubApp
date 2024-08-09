//
//  MainFeature.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import ComposableArchitecture
import enum SwiftUI.ScenePhase
import Foundation

struct MainFeature: ReducerProtocol {

	struct State: Equatable {
		var kaizenHomeState = HomeFeature.State()
		var productListState = ProductListFeature.State()
		var serviceListState = ServicesFeature.State()
		var eventListState = EventsFeature.State()
		var accountState = AccountFeature.State()

		var selectedTab: Tab
		var isAppLocked = true
		var appLastUsedAt: Date?

		var user: User?

	}

	enum Tab: Equatable {
		case home
		case products
		case services
		case events
		case account
	}

	 enum Action {
		 case tabChanged(Tab)
		 case home(HomeFeature.Action)
		 case productList(ProductListFeature.Action)
		 case servicesList(ServicesFeature.Action)
		 case eventsList(EventsFeature.Action)
		 case accountList(AccountFeature.Action)

		 case scenePhaseChanged(ScenePhase)
	 }


	@Dependency(\.mainQueue) private var mainQueue
	@Dependency(\.logger) private var logger

	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			struct CancelAuth: Hashable { }
			switch action {
			case .tabChanged(let newTab):
				state.selectedTab = newTab

				switch newTab {
				case .home:
					return .none
				case .products:
					return .none
				case .services:
					return .none
				case .events:
					return .none
				default:
					return .none
				}
			case .scenePhaseChanged(let newScenePhase):
				switch newScenePhase {
				case .background:
					state.appLastUsedAt = .now
					state.isAppLocked = true
					return .cancel(id: CancelAuth())

				case .inactive:
					state.isAppLocked = true
					return .none

				case .active:

					return .none

				@unknown default:
					logger.info("New ScenePhase arrived!")
					return .none
				}

			case .home:
				return .none
			case .productList:
				return .none
			case .servicesList:
				return .none
			case .eventsList:
				return .none
			case .accountList:
				return .none
			}
		}
//		Scope(state: \.kaizenHomeState, action: /Action.home) {
//			HomeFeature(fetchProducts: { Product.sample },sendOrder: { _ in "OK"})
//		}
		Scope(state: \.productListState, action: /Action.productList) {
			ProductListFeature()
		}
		Scope(state: \.serviceListState, action: /Action.servicesList) {
			ServicesFeature()
		}
		Scope(state: \.eventListState, action: /Action.eventsList) {
			EventsFeature(fetchEvents: { Event.sample },sendOrder: { _ in "OK"})
		}
		Scope(state: \.accountState, action: /Action.accountList) {
			AccountFeature()
		}
	}
}


