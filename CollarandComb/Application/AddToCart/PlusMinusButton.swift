//
//  PlusMinusButton.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import SwiftUI
import ComposableArchitecture

struct PlusMinusButton: View {

	let store: StoreOf<AddToCartFeature>

	@EnvironmentObject var cartManager: CartManager

	var body: some View {
		WithViewStore(self.store, observe: {$0}) { viewStore in

			HStack {

				Button {
//					self.cartManager.addToCart(product: <#T##Product#>)
					viewStore.send(.increaseCounter)
				} label: {
					Image(systemName: "plus.circle.fill")
						.font(.system(size: 30))
						.foregroundColor(.white)
				}

				Text("\(viewStore.count)")
					.fontWeight(.bold)
					.font(.system(size: 20))

				Button {
					viewStore.send(.decreaseCounter)
				} label: {
					Image(systemName: "minus.circle.fill")
						.font(.system(size: 30))
						.foregroundColor(.white)
				}
				.buttonStyle(.plain)
			}
		}
	}
}

struct PlusMinusButton_Previews: PreviewProvider {
	static var previews: some View {
		PlusMinusButton(store: Store(initialState: .init(), reducer: AddToCartFeature()))
	}
}

