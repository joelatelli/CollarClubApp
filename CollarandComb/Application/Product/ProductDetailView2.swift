//
//  ProductDetailView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/30/23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct ProductDetailView2: View {
	let store: StoreOf<ProductDetailFeature>

	@EnvironmentObject var cartManager: CartManager
	@EnvironmentObject private var userVM: UserViewModel

	@State var count = 1
	@State var total: Float = 0
	@State var products = [Product2]()
	@State var options = [String]()
	@State var firstOption = ""
	@State var secondOption = ""
	@State var thirdOption = ""

	private struct ViewState: Equatable {
		var product: Product2
		var count = 0
		var total: Float = 0

		init(state: ProductDetailFeature.State) {
			product = state.product
			count = state.count
			total = state.total
		}
	}

	var body: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
//			ZStack {
				ScrollView {
					Spacer()
						.frame(height: 20)
					VStack(alignment: .leading, spacing: 10) {
						WebImage(url: URL(string: viewStore.product.imageURL))
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: UIScreen.screenWidth - 30, height: 350)
							.cornerRadius(8)
							.shadow(radius: 5)
							.clipped()
							.padding(.bottom, 8)

						ModTextView(text: viewStore.product.title, type: .h4)
							.fixedSize(horizontal: false, vertical: true)
							.padding(.bottom, 10)
							.padding(.top, 10)

						HStack {

							ModTextView(text: "$\(viewStore.product.price.description)", type: .h5, lineLimit: 2).foregroundColor(Color.text_primary_color)

							Spacer()

							HStack {

								Button {
									count += 1
									total += viewStore.product.price
									viewStore.send(.increaseCounter)
								} label: {
									Image(systemName: "plus.circle.fill")
										.font(Font.system(size: 30, weight: .ultraLight))
										.foregroundColor(Color.text_primary_color)
								}

								ModTextView(text: "\(count)", type: .h6, lineLimit: 2).foregroundColor(Color.text_primary_color)

								Button {
									if self.count > 1 {
										count -= 1
										total -= viewStore.product.price
										viewStore.send(.decreaseCounter)
									}
								} label: {
									Image(systemName: "minus.circle.fill")
										.font(Font.system(size: 30, weight: .ultraLight))
										.foregroundColor(Color.text_primary_color)
								}
								.buttonStyle(.plain)
							}
						}
//						.frame(width: UIScreen.screenWidth)

						ModTextView(text: viewStore.product.desc, type: .body_1, lineLimit: 2).foregroundColor(Color.text_primary_color)
							.padding(.bottom, 20)


						coffeeOptions
							.padding(.bottom, 30)

						Button {
//							self.cartManager.addToCart(product: viewStore.product)
						} label: {
							HStack(alignment: .center) {
								Spacer()
								if self.count == 1 {
									ModTextView(text: "Add To Cart - $\(viewStore.product.price.description)", type: .subtitle_1, lineLimit: 2).foregroundColor(Color.text_primary_color)

								} else {
									ModTextView(text: "Add \(self.count) to Cart - $\(String(format: "%.2f", self.total))", type: .subtitle_1, lineLimit: 2).foregroundColor(Color.text_primary_color)
								}

								Spacer()
							}
							.frame(height: 50)
							.background(Color.gold_color)
							.cornerRadius(4)
							.padding(.bottom, 10)
						}
						.buttonStyle(.plain)

						Spacer()
							.frame(height: 40)
					}
					.padding(.horizontal, 10)
					.toolbar(content: toolbar)
				}

		}
	}

	private var coffeeOptions: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			VStack(alignment: .leading) {
				ModTextView(text: "Select Milk", type: .h6, lineLimit: 2).foregroundColor(Color.text_primary_color)

				FlexibleView(
					data: ["Whole", "Skim", "Táche Pistachio", "Califia Oat", "Califia Almond", "Soy", "2%", "Half & Half", "Heavy Cream"],
					spacing: 10,
					alignment: .leading
				) { todoStatus in
					makeOneChipsViewFor(todoStatus)
						.onTapGesture {
							if todoStatus == firstOption {
								viewStore.send(.removeFirstOption(todoStatus))
								firstOption = ""
							} else {
								viewStore.send(.addFirstOption(todoStatus))
								firstOption = todoStatus
							}
//							if options.contains(todoStatus) {
//								if let index = options.firstIndex(of: todoStatus) {
//									options.remove(at: index)
//								}
//								viewStore.send(.removeOption(todoStatus))
//							} else {
//								viewStore.send(.addOption(todoStatus))
//								options.append(todoStatus)
//							}
						}
				}
				.padding(.vertical, 10)
				.padding(.bottom, 14)

				ModTextView(text: "Extra Shot?", type: .h6, lineLimit: 2).foregroundColor(Color.text_primary_color)


				FlexibleView(
					data: ["One Extra Shot", "Two Extra Shots", "Three Extra Shots"],
					spacing: 10,
					alignment: .leading
				) { todoStatus in
					makeTwoChipsViewFor(todoStatus)
						.onTapGesture {
							if todoStatus == secondOption {
								viewStore.send(.removeSecondOption(todoStatus))
								secondOption = ""
							} else {
								viewStore.send(.addSecondOption(todoStatus))
								secondOption = todoStatus
							}
						}
				}
				.padding(.vertical, 10)


				ModTextView(text: "Sweetener?", type: .h6, lineLimit: 2).foregroundColor(Color.text_primary_color)

				FlexibleView(
					data: ["Simple Syrup", "1 pack white sugar", "1 pack sugar in raw", "1 pack stevia", "1 pack honey", "1 pack splenda"],
					spacing: 10,
					alignment: .leading
				) { todoStatus in
					makeThreeChipsViewFor(todoStatus)
						.onTapGesture {
							if todoStatus == thirdOption {
								viewStore.send(.removeThirdOption(todoStatus))
								thirdOption = ""
							} else {
								viewStore.send(.addThirdOption(todoStatus))
								thirdOption = todoStatus
							}
						}
				}
				.padding(.vertical, 10)

			}
		}
	}

	@ViewBuilder private func makeOneChipsViewFor(_ filterTag: String) -> some View {

		HStack {

			ModTextView(text: filterTag, type: .body_1, lineLimit: 2).foregroundColor(Color.primary_color)
				.padding(.horizontal, 5)

		}
		.padding(10)
		.foregroundColor(Color.black)
		.background(firstOption == filterTag ? Color.gold_color : Color.text_primary_color)
		.cornerRadius(4)
	}

	@ViewBuilder private func makeTwoChipsViewFor(_ filterTag: String) -> some View {

		HStack {

			ModTextView(text: filterTag, type: .body_1, lineLimit: 2).foregroundColor(Color.primary_color)
				.padding(.horizontal, 5)

		}
		.padding(10)
		.foregroundColor(Color.black)
		.background(secondOption == filterTag ? Color.gold_color : Color.text_primary_color)
		.cornerRadius(4)
	}

	@ViewBuilder private func makeThreeChipsViewFor(_ filterTag: String) -> some View {

		HStack {

			ModTextView(text: filterTag, type: .body_1, lineLimit: 2).foregroundColor(Color.primary_color)
				.padding(.horizontal, 5)

		}
		.padding(10)
		.foregroundColor(Color.black)
		.background(thirdOption == filterTag ? Color.gold_color : Color.text_primary_color)
		.cornerRadius(4)
	}
}

extension ProductDetailView2 {
	private func toolbar() -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			WithViewStore(store) { viewStore in
				HStack(spacing: 6) {
					Button {
						if (userVM.favoriteProducts.contains(where: { $0.id == viewStore.product.id  }) == true) {
							viewStore.send(.unfavorite, animation: .easeInOut)
							if let idx = userVM.favoriteProducts.firstIndex(where: { $0.id == viewStore.product.id }) {
								userVM.favoriteProducts.remove(at: idx)
							}
						} else {
							viewStore.send(.favorite, animation: .easeInOut)
							userVM.favoriteProducts.append(viewStore.product)
						}
					} label: {
						if (userVM.favoriteProducts.contains(where: { $0.id == viewStore.product.id  }) == true) {
							Image(systemName: "bookmark.fill")
								.frame(minWidth: 20)
								.contentShape(Rectangle())
								.padding(6)
						} else {
							Image(systemName: "bookmark")
								.frame(minWidth: 20)
								.contentShape(Rectangle())
								.padding(6)
						}
					}
//					Image(systemName: "bookmark")
//						.frame(minWidth: 20)
//						.contentShape(Rectangle())
//						.padding(6)
//						.onTapGesture {
//							if (userVM.favoriteProducts.contains(where: { $0.id == viewStore.product.id  }) == true) {
//								viewStore.send(.unfavorite, animation: .easeInOut)
//								if let idx = userVM.favoriteProducts.firstIndex(where: { $0.id == viewStore.product.id }) {
//									userVM.favoriteProducts.remove(at: idx)
//								}
//							} else {
//								viewStore.send(.favorite, animation: .easeInOut)
//								userVM.favoriteProducts.append(viewStore.product)
//							}
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
}
