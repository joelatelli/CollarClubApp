//
//  GradientView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/9/23.
//

import SwiftUI

struct BigGradient: View {

  var body: some View {
	  ZStack {
		  Color.primary_color

		  LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.20),
													 Color.black.opacity(0.05),
													 Color.black.opacity(0.0)]),
					   startPoint: .top,
					   endPoint: .bottom)
	  }

  }

}
