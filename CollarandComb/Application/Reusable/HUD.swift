//
//  HUD.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/16/23.
//

import Foundation
import SwiftUI

struct HUD: View {
	private let backgroundColor: Color
	private let iconName: String?
	private let message: String

	init(message: String, iconName: String? = nil, backgroundColor: Color) {
		self.message = message
		self.iconName = iconName
		self.backgroundColor = backgroundColor
	}

	var body: some View {
		HStack(alignment: .center) {
			if let iconName {
				Image(systemName: iconName)
			}

			ModTextView(text: message, type: .body_1)
				.multilineTextAlignment(.center)

		}
		.padding(.horizontal, 12)
		.padding(16)
		.frame(maxWidth: .infinity)
		.background(
			RoundedRectangle(cornerRadius: 4)
				.fill(Color.gold_color)
				.opacity(0.9)
				.shadow(color: .black.opacity(0.25), radius: 35, x: 0, y: 5)
		)
	}
}
