//
//  TimelineContentFilterView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import SwiftUI

struct TimelineContentFilterView: View {
	@Environment(Theme.self) private var theme

	@State private var contentFilter = TimelineContentFilter.shared

	init() {}

	var body: some View {
		Form {
			Section {
				Toggle(isOn: $contentFilter.showBoosts) {
					Label("timeline.filter.show-boosts", image: "Rocket")
				}
				Toggle(isOn: $contentFilter.showReplies) {
					Label("timeline.filter.show-replies", systemImage: "bubble.left.and.bubble.right")
				}
				Toggle(isOn: $contentFilter.showThreads) {
					Label("timeline.filter.show-threads", systemImage: "bubble.left.and.text.bubble.right")
				}
				Toggle(isOn: $contentFilter.showQuotePosts) {
					Label("timeline.filter.show-quote", systemImage: "quote.bubble")
				}
			}
			.listRowBackground(theme.primaryBackgroundColor)
		}
		.navigationTitle("timeline.content-filter.title")
		.navigationBarTitleDisplayMode(.inline)
		.scrollContentBackground(.hidden)
		.background(theme.secondaryBackgroundColor)
	}
}

