//
//  CartButton.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/31/23.
//

import SwiftUI

struct CartButton: View {
	@Environment(CartManager.self) private var cartManager
	@Environment(Theme.self) private var theme

	var numberOfProducts: Int
	var body: some View {

		ZStack(alignment: .topTrailing){
			Image(systemName: "cart")
				.frame(minWidth: 20)
				.contentShape(Rectangle())
				.padding(6)
				.foregroundColor(theme.tintColor)

			if numberOfProducts > 0 {
				Text("\(cartManager.products.count)").font(.caption2).bold().foregroundColor(.white).frame(width: 15,height: 15).background(.red).cornerRadius(50)
			}
		}
	}
}

struct CartButton_Previews: PreviewProvider {
	static var previews: some View {
		CartButton(numberOfProducts: 1)
	}
}
