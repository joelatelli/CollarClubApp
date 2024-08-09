//
//  ProductListView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct ProductListView: View {

	let store: StoreOf<ProductListFeature>
	@EnvironmentObject var cartManager: CartManager
	@EnvironmentObject private var userVM: UserViewModel

	@State private var showSeasonal = false
	@State private var showAwardWinning = false
	@State private var showMostFollowed = false

	@State var greetingText = "Hello"

	private struct ViewState: Equatable {
		let isRefreshActionInProgress: Bool
		let areSeasonalTitlesFetched: Bool
		let areLatestUpdatesFetched: Bool
		let areAwardWinningTitlesFetched: Bool
		let areMostFollowedTitlesFetched: Bool
		let seasonalMangaTabName: String

		init(state: ProductListFeature.State) {
			isRefreshActionInProgress = state.isRefreshActionInProgress
			areSeasonalTitlesFetched = !state.productList.isEmpty
			areLatestUpdatesFetched = !state.productList.isEmpty
			areAwardWinningTitlesFetched = !state.productList.isEmpty
			areMostFollowedTitlesFetched = !state.productList.isEmpty
			seasonalMangaTabName = state.seasonalTabName ?? "Seasonal"
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

						HStack {

							ModTextView(text: "\(greetingText), \(userVM.me.firstName)!", type: .h4)
								.fixedSize(horizontal: false, vertical: true)
								.padding(.bottom, 10)
								.padding(.top, 10)

							Spacer()

						}
						.padding(.horizontal, 10)

						TabView {
							seasonalNavLink
								.padding(.horizontal)

							mostFollowedNavLink
								.padding(.horizontal)

//							awardWinningNavLink
//								.padding(.horizontal)
						}
						.frame(height: 200)
						.tabViewStyle(.page(indexDisplayMode: .always))
						.padding(.bottom, 20)

						VStack(spacing: 2) {
							ForEachStore(
								self.store.scope(
									state: \.productList,
									action: ProductListFeature.Action.productRowAction
								)
							) {
								ProductRow(store: $0)
							}
						}

						footer

					}
				}
				.task {
					greetingLogic()
					viewStore.send(.onAppear)
				}
			}
			.toolbar(content: toolbarLeading)
			.toolbar(content: toolbar)
			.navigationTitle("Collar and Foam")
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Color.gold_color, for: .navigationBar)
		}
	}
	func greetingLogic() {
	  let hour = Calendar.current.component(.hour, from: Date())

	  let NEW_DAY = 0
	  let NOON = 12
	  let SUNSET = 18
	  let MIDNIGHT = 24

	  switch hour {
	  case NEW_DAY..<NOON:
		  greetingText = "Good Morning"
	  case NOON..<SUNSET:
		  greetingText = "Good Afternoon"
	  case SUNSET..<MIDNIGHT:
		  greetingText = "Good Evening"
	  default:
		  _ = "Hello"
	  }

	}
}

extension ProductListView {
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

extension ProductListView {
	private var latestUpdates: some View {
		Section {
			VStack(alignment: .center) {
				WithViewStore(store, observe: ViewState.init) { viewStore in
					if viewStore.areLatestUpdatesFetched {
						ForEachStore(
							self.store.scope(
								state: \.productList,
								action: ProductListFeature.Action.productRowAction
							)
						) {
							ProductRow(store: $0)
						}
					} else {
						EmptyView()

					}
				}

				footer
			}
		} header: {
			Text("Latest updates")
				.font(.title3)
				.fontWeight(.semibold)
				.padding(.horizontal)
				.padding(.bottom, 10)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(
					LinearGradient(
						colors: [.gold_color, .gold_color, .gold_color, .clear],
						startPoint: .top,
						endPoint: .bottom
					)
				)
		}
	}
}


// MARK: - Seasonal
extension ProductListView {
	private var seasonalNavLink: some View {
		NavigationLink(isActive: $showSeasonal) {
			seasonal
		} label: {
			ZStack(alignment: .bottomLeading) {
				WebImage(url: URL(string: "https://images.pexels.com/photos/3151778/pexels-photo-3151778.jpeg?auto=compress&cs=tinysrgb&w=1600"))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(height: 200)
					.cornerRadius(6)
					.overlay {
						LinearGradient(
							colors: [.gold_color, .gold_color.opacity(0.4)],
							startPoint: .bottomLeading,
							endPoint: .top
						)
						.cornerRadius(6)
					}

				VStack(alignment: .leading) {
					ModTextView(text: "Seasonal Food", type: .h5)
						.multilineTextAlignment(.leading)
						.foregroundColor(.white)
						.padding(.leading, 30)
					ModTextView(text: "and Drinks", type: .h5)
						.multilineTextAlignment(.leading)
						.foregroundColor(.white)
						.padding(.bottom, 30)
						.padding(.leading, 30)
				}
			}
			.frame(height: 200)
		}
	}

	private var seasonal: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			VStack {
//				Text("by oolxg")
//					.font(.caption2)
//					.frame(height: 0)
//					.foregroundColor(.clear)

				ScrollView {
//					if viewStore.areSeasonalTitlesFetched {
//						ForEachStore(
//							self.store.scope(
//								state: \.productList,
//								action: ProductListFeature.Action.productRowAction
//							)
//						) {
//							ProductRow(store: $0)
//						}
//					} else {
//						EmptyView()
//
//					}
					EmptyView()

				}
				.navigationTitle("Seasonal")
				.navigationBarBackButtonHidden(false)
//				.toolbar {
//					toolbar { showSeasonal = false }
//				}
			}
		}
	}
}

// MARK: - Most Followed
extension ProductListView {
	private var mostFollowedNavLink: some View {
		NavigationLink(isActive: $showMostFollowed) {
			mostFollowed
		} label: {
			ZStack(alignment: .bottomLeading) {
				WebImage(url: URL(string: "https://images.pexels.com/photos/4349800/pexels-photo-4349800.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(height: 200)
					.cornerRadius(6)
					.overlay {
						LinearGradient(
							colors: [.gold_color, .gold_color.opacity(0.4)],
							startPoint: .bottomLeading,
							endPoint: .top
						)
						.cornerRadius(6)
					}

				VStack(alignment: .leading) {
					ModTextView(text: "Staff", type: .h5M)
						.multilineTextAlignment(.leading)
						.foregroundColor(.white)
						.padding(.leading, 30)
					ModTextView(text: "Favorites", type: .h5M)
						.multilineTextAlignment(.leading)
						.foregroundColor(.white)
						.padding(.bottom, 30)
						.padding(.leading, 30)
				}
			}
			.frame(height: 200)
		}
	}

	private var mostFollowed: some View {
		VStack {

			ScrollView {
				VStack {
//					WithViewStore(store, observe: ViewState.init) { viewStore in
//						if viewStore.areMostFollowedTitlesFetched {
//							ForEachStore(
//								self.store.scope(
//									state: \.productList,
//									action: ProductListFeature.Action.productRowAction
//								)
//							) {
//								ProductRow(store: $0)
//							}
//						} else {
//							EmptyView()
//
//						}
//					}
					EmptyView()

				}
			}
		}
		.navigationTitle("Staff Favorites")
		.navigationBarBackButtonHidden(false)
//		.toolbar {
//			toolbar { showMostFollowed = false }
//		}
//		.onAppear {
//			ViewStore(store).send(.onAppearMostFollewedManga)
//		}
	}
}

// MARK: - Award Winning
extension ProductListView {
	private var awardWinningNavLink: some View {
		NavigationLink(isActive: $showAwardWinning) {
			awardWinning
		} label: {
			ZStack(alignment: .bottomLeading) {
				RoundedRectangle(cornerRadius: 6)
					.fill(
						LinearGradient(
							colors: [.green, .blue],
							startPoint: .bottomLeading,
							endPoint: .top
						)
					)
					.overlay {
						Image(systemName: "trophy.fill")
							.resizable()
							.scaledToFit()
							.foregroundColor(.white)
							.frame(width: 60, height: 60)
					}

				VStack(alignment: .leading, spacing: 0) {
					Text("Award")
					Text("Winning")
				}
				.foregroundColor(.white)
				.multilineTextAlignment(.leading)
				.font(.headline)
				.padding(.bottom, 10)
				.padding(.leading, 10)
			}
			.frame(height: 170)
		}
	}

	private var awardWinning: some View {
		VStack {
			Text("by oolxg")
				.font(.caption2)
				.frame(height: 0)
				.foregroundColor(.clear)

			ScrollView {
				VStack {
					WithViewStore(store, observe: ViewState.init) { viewStore in
						if viewStore.areAwardWinningTitlesFetched {
							ForEachStore(
								self.store.scope(
									state: \.productList,
									action: ProductListFeature.Action.productRowAction
								)
							) {
								ProductRow(store: $0)
							}
						} else {
							EmptyView()
						}
					}
				}
			}
		}
		.navigationTitle("Award Winning")
		.navigationBarBackButtonHidden(false)
//		.toolbar {
//			toolbar { showAwardWinning = false }
//		}
//		.onAppear {
//			ViewStore(store).send(.onAppearAwardWinningManga)
//		}
	}

	private var footer: some View {
		HStack(spacing: 0) {
			ModTextView(text: "All products are made fresh upon order by ", type: .caption)
				.foregroundColor(.gray)

			ModTextView(text: "COLLAR & COMB™", type: .caption)
				.foregroundColor(.gold_color)
		}
		.font(.caption2)
		.padding(.horizontal)
		.padding(.top, 24)
		.padding(.bottom, 20)
	}
}
