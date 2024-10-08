//
//  TimelineHeaderView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import SwiftUI

struct TimelineHeaderView<Content: View>: View {
  @Environment(Theme.self) private var theme

  var content: () -> Content

  var body: some View {
	VStack(alignment: .leading) {
	  Spacer()
	  content()
	  Spacer()
	}
	.listRowBackground(theme.secondaryBackgroundColor)
	.listRowSeparator(.hidden)
	.listRowInsets(.init(top: 8,
						 leading: .layoutPadding,
						 bottom: 8,
						 trailing: .layoutPadding))
  }
}

