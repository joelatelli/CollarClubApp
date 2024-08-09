//
//  RecentTagsView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import EmojiText
import Foundation
import SwiftUI
import SwiftData


extension ProductEditor.AutoCompleteView  {
  struct RecentTagsView: View {
	@Environment(Theme.self) private var theme

	var viewModel: ProductEditor.ViewModel
	@Binding var isTagSuggestionExpanded: Bool

	@Query(sort: \RecentTag.lastUse, order: .reverse) var recentTags: [RecentTag]

	var body: some View {
	  ForEach(recentTags) { tag in
		Button {
		  withAnimation {
			isTagSuggestionExpanded = false
			viewModel.selectHashtagSuggestion(tag: tag.title)
		  }
		  tag.lastUse = Date()
		} label: {
		  VStack(alignment: .leading) {
			Text("#\(tag.title)")
			  .font(.scaledFootnote)
			  .fontWeight(.bold)
			  .foregroundColor(theme.labelColor)
			Text(tag.formattedDate)
			  .font(.scaledFootnote)
			  .foregroundStyle(theme.tintColor)
		  }
		}
	  }
	}
  }
}

