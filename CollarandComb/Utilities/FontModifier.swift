//
//  FontModifier.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/9/23.
//

import SwiftUI

enum BarlowFontType: String {
	case black = "Barlow-Black"
	case bold = "Barlow-Bold"
	case extraBold = "Barlow-ExtraBold"
	case extraLight = "Barlow-ExtraLight"
	case light = "Barlow-Light"
	case medium = "Barlow-Medium"
	case regular = "Barlow-Regular"
	case semiBold = "Barlow-SemiBold"
	case thin = "Barlow-Thin"
}

struct BarlowFont: ViewModifier {

	var type: BarlowFontType
	var size: CGFloat

	init(_ type: BarlowFontType = .regular, size: CGFloat = 18) {
		self.type = type
		self.size = size
	}

	func body(content: Content) -> some View {
		content.font(Font.custom(type.rawValue, size: size))
	}
}


