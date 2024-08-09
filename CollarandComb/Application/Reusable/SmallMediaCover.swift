//
//  SmallMediaCover.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SmallMediaCover: View {
	var imageURL: String

	var body: some View {
		HStack {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(.gray)
				.overlay(
					WebImage(url: URL(string: imageURL))
						.resizable()
						.scaledToFill()
				)
				.mask(Circle().frame(width: 100, height: 100))
				.frame(width: 100, height: 100)
//				.shadow(color: .secondary_color.opacity(0.3), radius: 15)
		}
		.padding(.bottom, 10)
	}
}
