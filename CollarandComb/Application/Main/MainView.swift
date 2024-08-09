//
//  MainView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
	let store: StoreOf<MainFeature>
	@Environment(\.scenePhase) private var scenePhase

	@StateObject private var hudState = HUDClient.liveValue
	@StateObject var cartManager = CartManager()
	@StateObject var userVM = UserViewModel()

	@State private var isSignedIn = AuthServiceFactory.create().token != nil

	@State var splashScreen  = true

	private struct ViewState: Equatable {
		let selectedTab: MainFeature.Tab

		init(state: MainFeature.State) {
			selectedTab = state.selectedTab
		}
	}

	var body: some View {
		if isSignedIn {
			ZStack {
				if splashScreen {
					SplashScreen()
				} else {
					WithViewStore(store, observe: ViewState.init) { viewStore in
						TabView(selection: viewStore.binding(get: \.selectedTab, send: MainFeature.Action.tabChanged)) {

							ProductListView(
								store: store.scope(
									state: \.productListState,
									action: MainFeature.Action.productList
								)
							)
							.tabItem {
								Image(systemName: "cart")
								Text("Food and Drinks")
							}
							.tag(MainFeature.Tab.products)

							ServicesView(
								store: store.scope(
									state: \.serviceListState,
									action: MainFeature.Action.servicesList
								)
							)
							.tabItem {
								Image(systemName: "scissors")
								Text("Grooming")
							}
							.tag(MainFeature.Tab.services)

							EventsView(
								store: store.scope(
									state: \.eventListState,
									action: MainFeature.Action.eventsList
								)
							)
							.tabItem {
								Image(systemName: "map")
								Text("Events")
							}
							.tag(MainFeature.Tab.events)

							AccountView(
								store: store.scope(
									state: \.accountState,
									action: MainFeature.Action.accountList
								)
							)
							.tabItem {
								Image(systemName: "person")
								Text("Account")
							}
							.tag(MainFeature.Tab.account)


						}
						.hud(
							isPresented: $hudState.isPresented,
							message: hudState.message,
							iconName: hudState.iconName,
							backgroundColor: hudState.backgroundColor
						)
						.onChange(of: scenePhase) { viewStore.send(.scenePhaseChanged($0)) }
						.environmentObject(cartManager)
						.environmentObject(userVM)
					}
					.accentColor(Color.gold_color)
					.navigationViewStyle(.stack)

				}
			}
			.onAppear {
				self.userVM.setMe()
				DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
					withAnimation {
						self.splashScreen = false
					}
				}
			}
		} else {
			SignInView(isSignedIn: $isSignedIn)
		}
	}
}

