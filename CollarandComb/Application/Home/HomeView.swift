//
//  HomeView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct HomeView: View {
	let store: StoreOf<HomeFeature>

	@Environment(\.colorScheme) private var colorScheme

	private struct ViewState: Equatable {


		init(state: HomeFeature.State) {

		}
	}

	var body: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			personTodos
		}
	}

	private var personTodos: some View {
		NavigationView {
			WithViewStore(store, observe: ViewState.init) { viewStore in
				ZStack {
					Text("Hello World")
				}
			}
		}
	}
}
