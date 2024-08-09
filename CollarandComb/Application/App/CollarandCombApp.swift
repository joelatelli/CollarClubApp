//
//  CollarandCombApp.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import SwiftUI
import ComposableArchitecture

//@main
struct Kaizen_API_App_TestApp: App {

//	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	let center = UNUserNotificationCenter.current()

	init() {
		UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Barlow-Regular", size: 32)!]
		UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Barlow-Regular", size: 18)!]
	}

	let store: StoreOf<AppFeature> = .init(
		initialState: AppFeature.State(rootState: .init(selectedTab: .home)),
		reducer: AppFeature()
	)

	struct ViewState: Equatable {
		init(state: AppFeature.State) {
			print("Hello World --")
		}
	}

	var body: some Scene {
		WindowGroup {
			WithViewStore(store, observe: ViewState.init) { viewStore in
				MainView(
					store: store.scope(
						state: \.rootState,
						action: AppFeature.Action.rootAction
					)
				)
				.onAppear {
					viewStore.send(.initApp)
				}
			}
		}
	}
}


//@main
//struct CollarandCombApp: App {
//	let persistenceController = PersistenceController.shared
//
//	var body: some Scene {
//		WindowGroup {
//			ContentView()
//				.environment(\.managedObjectContext, persistenceController.container.viewContext)
//		}
//	}
//}
