//
//  EventsView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct EventsView: View {
	let store: StoreOf<EventsFeature>

	@Environment(\.colorScheme) private var colorScheme
	@EnvironmentObject var cartManager: CartManager

	private struct ViewState: Equatable {

		init(state: EventsFeature.State) {

		}
	}

	var body: some View {
		NavigationView {
			WithViewStore(self.store) { viewStore in
				ZStack(alignment: .center) {
					BigGradient()
						.ignoresSafeArea()

					ScrollView {
						Spacer()
							.frame(height: 20)
						VStack(spacing: 2) {
							ForEachStore(
								self.store.scope(
									state: \.eventList,
									action: EventsFeature.Action.event
								)
							) {
								EventRowView2(store: $0)
							}
						}
						.task {
							viewStore.send(.fetchProducts)
						}
					}
				}
			}
//			.toolbar(content: toolbar)
			.navigationTitle("Upcoming Events")
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Color.gold_color, for: .navigationBar)
		}
	}

	private var personTodos: some View {
		NavigationView {
			WithViewStore(store, observe: ViewState.init) { viewStore in
				ZStack {
					Text("Events View")
				}
			}
		}
	}
}

extension EventsView {
	private func toolbar() -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			WithViewStore(store) { viewStore in
				HStack(spacing: 6) {
					Image(systemName: "info.circle")
						.frame(minWidth: 20)
						.contentShape(Rectangle())
						.padding(6)
						.onTapGesture {
							print("Cart")
						}

					NavigationLink {
//					   CartView().environmentObject(cartManager)

					} label: {
					   CartButton(numberOfProducts: cartManager.products.count)
					}
				}
			}
		}
	}

	private func toolbarLeading() -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			WithViewStore(store) { viewStore in
				HStack(spacing: 6) {
					Image(systemName: "person.crop.circle")
						.foregroundColor(.text_primary_color)
						.frame(minWidth: 20)
						.contentShape(Rectangle())
						.padding(6)
				}
			}
		}
	}
}
