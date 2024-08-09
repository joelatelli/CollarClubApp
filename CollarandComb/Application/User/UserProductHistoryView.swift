//
//  UserProductHistoryView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/24/23.
//

import SwiftUI
import ComposableArchitecture

struct UserProductHistoryView: View {

	let store: StoreOf<UserSavedProductsFeature>
	@EnvironmentObject var cartManager: CartManager

	var body: some View {
		NavigationView {
			WithViewStore(self.store) { viewStore in
				ZStack(alignment: .center) {
					BigGradient()
						.ignoresSafeArea()
					ScrollView {

						Spacer()
							.frame(height: 20)

						HStack {

							ModTextView(text: "Good evening, Joel!", type: .h4)
								.fixedSize(horizontal: false, vertical: true)
								.padding(.bottom, 10)
								.padding(.top, 10)

							Spacer()

						}
						.padding(.horizontal, 10)

						VStack(spacing: 2) {
							ForEachStore(
								self.store.scope(
									state: \.productList,
									action: UserSavedProductsFeature.Action.productRowAction
								)
							) {
								ProductRow(store: $0)
							}
						}
						.task {
							viewStore.send(.fetchProducts)
						}
					}
				}
			}
			.toolbar(content: toolbarLeading)
			.toolbar(content: toolbar)
			.navigationTitle("Collar and Foam")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

extension UserProductHistoryView {
	private func toolbar() -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			WithViewStore(store) { viewStore in
				HStack(spacing: 6) {
//					Image(systemName: "cart")
//						.frame(minWidth: 20)
//						.contentShape(Rectangle())
//						.padding(6)
//						.onTapGesture {
//							print("Cart")
//						}
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

