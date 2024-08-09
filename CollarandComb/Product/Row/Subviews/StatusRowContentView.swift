//
//  StatusRowContentView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

struct StatusRowContentView: View {
  @Environment(\.redactionReasons) private var reasons
  @Environment(\.isCompact) private var isCompact
  @Environment(\.isStatusFocused) private var isFocused

  @Environment(Theme.self) private var theme

  var viewModel: ProductRowViewModel

  var body: some View {

	if !viewModel.displaySpoiler {
	  StatusRowTextView(viewModel: viewModel)

//		if !(viewModel.finalProduct.mediaAttachments?.isEmpty ?? true) {
//		HStack {
//			StatusRowMediaPreviewView(attachments: viewModel.finalProduct.mediaAttachments ?? [],
//									sensitive: false)
//		  if theme.statusDisplayStyle == .compact {
//			Spacer()
//		  }
//		}
//		.accessibilityHidden(isFocused == false)
//		.padding(.vertical, 4)
//	  }

//	  if let card = viewModel.finalProduct.card,
//		 !viewModel.isEmbedLoading,
//		 !isCompact,
//		 theme.statusDisplayStyle != .compact,
//		 viewModel.embeddedStatus == nil,
//		 ((viewModel.finalProduct.mediaAttachments?.isEmpty) != nil)
//	  {
//		StatusRowCardView(card: card)
//	  }
	}
  }
}

