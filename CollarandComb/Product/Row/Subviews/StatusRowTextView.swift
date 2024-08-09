//
//  StatusRowTextView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

@MainActor
struct StatusRowTextView: View {
  @Environment(Theme.self) private var theme
  @Environment(\.isStatusFocused) private var isFocused

  @Environment(ProductDataController.self) private var statusDataController

  var viewModel: ProductRowViewModel

  var body: some View {
	VStack(alignment: .leading, spacing: 4) {

		Text(viewModel.product.name)
		  .lineLimit(2)

		Text(viewModel.product.desc)
			.font(.system(size: 14))
			.lineLimit(2)

		HStack {
			Text("$\(viewModel.product.price)")
			  .lineLimit(2)
			  .foregroundColor(theme.tintColor)

			Spacer()
		}
	}
	.frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  func makeCollapseButton() -> some View {
	if let _ = viewModel.lineLimit {
	  HStack(alignment: .top) {
		Text("status.show-full-post")
		  .font(.system(.subheadline, weight: .bold))
		  .foregroundColor(.secondary)
		Spacer()
		Button {
		  withAnimation {
			viewModel.isCollapsed.toggle()
		  }
		} label: {
		  Image(systemName: "chevron.down")
		}
		.buttonStyle(.bordered)
		.accessibility(label: Text("status.show-full-post"))
		.accessibilityHidden(true)
	  }
	  .contentShape(Rectangle())
	  .onTapGesture { // make whole row tapable to make up for smaller button size
		withAnimation {
		  viewModel.isCollapsed.toggle()
		}
	  }
	}
  }
}

