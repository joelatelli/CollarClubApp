//
//  Color.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/9/23.
//

import SwiftUI

extension Color {
	static func random() -> Color {
		random(opacityRange: 1...1)
	}

	static func random(opacityRange rng: ClosedRange<Double>) -> Color {
		Color(UIColor.random(opacityLowerBound: CGFloat(rng.lowerBound),
							 opacityUpperBound: CGFloat(rng.upperBound)))
	}
}

extension Color {

	static let main_color = Color("main_color")
	static let gold_color = Color("collar_gold")
	static let primary_color = Color("primary")
	static let secondary_color = Color("secondary_a")
	static let third_color = Color("secondary")
	static let text_primary_color = Color("textPrimary_33_F2")
	static let text_secondary_color = Color("textSecondary_4F_F2")
	static let placeholder_color = Color(UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0))

	static let main_green = Color(UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1.0))
	static let main_red = Color(UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 1.0))

	init(hex: String, alpha: Double = 1) {
		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }

		let scanner = Scanner(string: cString)
		scanner.currentIndex = scanner.string.startIndex
		var rgbValue: UInt64 = 0
		scanner.scanHexInt64(&rgbValue)
		let r = (rgbValue & 0xff0000) >> 16
		let g = (rgbValue & 0xff00) >> 8
		let b = rgbValue & 0xff
		self.init(.sRGB, red: Double(r) / 0xff, green: Double(g) / 0xff, blue:  Double(b) / 0xff, opacity: alpha)
	}
}

extension UIColor {

	static let primary_color = UIColor(named: "primary")

	convenience init(hex: String, alpha: CGFloat = 1.0) {
		var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

		if hexFormatted.hasPrefix("#") {
			hexFormatted = String(hexFormatted.dropFirst())
		}

		assert(hexFormatted.count == 6, "Invalid hex code used.")

		var rgbValue: UInt64 = 0
		Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

		self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
				  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
				  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
				  alpha: alpha)
	}
}

extension UIColor {
	static func random(opacityLowerBound lower: CGFloat, opacityUpperBound upper: CGFloat) -> UIColor {
		let opacityLower = max(min(lower,upper), 0)
		let opacityUpper = min(max(lower,upper), 1)

		let opacity: CGFloat = stride(from: opacityLower, to: opacityUpper, by: 0.01)
			.map { $0 }
			.shuffled()
			.randomElement() ?? (Bool.random() ? lower : upper)

		return random(opacity: opacity)
	}

	static func random(opacity: CGFloat = 1) -> UIColor {
		let getRand: () -> CGFloat = {
			return stride(from: 0.0, to: 1.0, by: 0.01)
				.map { $0 }
				.shuffled()
				.randomElement() ?? (Bool.random() ? 0 : 1)
		}

		return UIColor(red: getRand(), green: getRand(), blue: getRand(), alpha: opacity)
	}

	var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		return (red, green, blue, alpha)
	}

}

public extension Color {
	static var wrappedPink: Color {
		return Color(.sRGB, red: 205/255, green: 21/255, blue: 130/255, opacity: 1.0)
	}

	static var wrappedTeal: Color {
		return Color(.sRGB, red: 165/255, green: 254/255, blue: 240/255, opacity: 1.0)
	}

	static var wrappedGreen: Color {
		return Color(.sRGB, red: 203/255, green: 244/255, blue: 91/255, opacity: 1.0)
	}

	static var wrappedBlue: Color {
		return Color(.sRGB, red: 65/255, green: 0/255, blue: 247/255, opacity: 1.0)
	}

}

struct Colors {
	static let appPink = UIColor(red: 236/255, green: 61/255, blue: 107/255, alpha: 1)
	static let appGreen = UIColor(red: 0/255, green: 159/255, blue: 6/255, alpha: 1)
}


