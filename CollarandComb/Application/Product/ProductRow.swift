//
//  ProductRow.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct ProductRow: View {

	let store: StoreOf<ProductRowFeature>
	@EnvironmentObject var cartManager: CartManager

	private struct ViewState: Equatable {
		let product: Product2

		init(state: ProductRowFeature.State) {
			product = state.product
		}
	}

	var body: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			HStack {
				VStack {
					WebImage(url: URL(string: viewStore.product.imageURL))
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 80, height: 80)
						.cornerRadius(4)

					Spacer()
				}
				.padding(.trailing, 6)

				VStack(alignment: .leading, spacing: 4) {
					
//					Text(viewStore.product.title)
//						.fontWeight(.bold)
					
					ModTextView(text: viewStore.product.title, type: .subtitle_1B, lineLimit: 2).foregroundColor(Color.text_primary_color)

					ModTextView(text:  viewStore.product.desc, type: .caption, lineLimit: 2).foregroundColor(Color.gray)

//					Text(viewStore.product.desc)
//						.lineLimit(2)
//						.foregroundColor(.gray)

					HStack {
						ModTextView(text: "$\(viewStore.product.price.description)", type: .subtitle_2, lineLimit: 2).foregroundColor(Color.gold_color)

//						Text("$\(viewStore.product.price.description)")
//							.fontWeight(.bold)
						Spacer()
						
//						AddToCartButton(
//							store: self.store.scope(
//								state: \.addToCartState,
//								action: ProductRowFeature.Action.addToCart
//							)
//						)
					}
				}
			}
			.padding(8)
			.onTapGesture {
				ViewStore(store).binding(\.$navigationLinkActive).wrappedValue.toggle()
			}
			.overlay(navigationLink)
		}
	}

	private var navigationLink: some View {
		WithViewStore(store) { viewStore in
			NavigationLink(
				isActive: viewStore.binding(\.$navigationLinkActive),
				destination: { productDetailView },
				label: { EmptyView() }
			)
		}
	}

	private var productDetailView: some View {
		EmptyView()
//		WithViewStore(store, observe: ViewState.init) { viewStore in
//			ProductDetailView(
//				store: store.scope(
//					state: \.productDetailState!,
//					action: ProductRowFeature.Action.productDetailAction
//				)
//			)
//		}
	}
}


