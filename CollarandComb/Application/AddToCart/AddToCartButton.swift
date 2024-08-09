//
//  AddToCartButton.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import SwiftUI
import ComposableArchitecture

struct AddToCartButton: View {

	let store: StoreOf<AddToCartFeature>
	@EnvironmentObject var cartManager: CartManager

	var body: some View {
		WithViewStore(self.store, observe: {$0}) { viewStore in
			if viewStore.state.count > 0 {
				PlusMinusButton(store: self.store )
			} else {
				Button {
					viewStore.send(.increaseCounter)
				} label: {
					Image(systemName: "plus.circle.fill")
						.font(.system(size: 30))
						.foregroundColor(.white)
				}
				.buttonStyle(.plain)
			}
		}
	}
}

struct AddToCartButton_Previews: PreviewProvider {

	static var previews: some View {
		AddToCartButton(store: Store(initialState: .init(),
									 reducer: AddToCartFeature()))
	}
}

