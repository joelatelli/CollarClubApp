//
//  TimelineContentFilter.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import Foundation
import SwiftUI

@MainActor
@Observable class TimelineContentFilter {
	class Storage {
		@AppStorage("timeline_show_boosts") var showBoosts: Bool = true
		@AppStorage("timeline_show_replies") var showReplies: Bool = true
		@AppStorage("timeline_show_threads") var showThreads: Bool = true
		@AppStorage("timeline_quote_posts") var showQuotePosts: Bool = true
	}

	static let shared = TimelineContentFilter()
	private let storage = Storage()

	var showBoosts: Bool {
		didSet {
			storage.showBoosts = showBoosts
		}
	}

	var showReplies: Bool {
		didSet {
			storage.showReplies = showReplies
		}
	}

	var showThreads: Bool {
		didSet {
			storage.showThreads = showThreads
		}
	}

	var showQuotePosts: Bool {
		didSet {
			storage.showQuotePosts = showQuotePosts
		}
	}

	private init() {
		showBoosts = storage.showBoosts
		showReplies = storage.showReplies
		showThreads = storage.showThreads
		showQuotePosts = storage.showQuotePosts
	}
}

