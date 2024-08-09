//
//  StatusAction.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

enum ProductAction: String, CaseIterable, Identifiable {
	public var id: String {
		"\(rawValue)"
	}

	case none, bookmark

	public func displayName(isBookmarked: Bool = false, privateBoost: Bool = false) -> LocalizedStringKey {
		switch self {
		case .none:
			return "settings.swipeactions.status.action.none"
		case .bookmark:
			return isBookmarked ? "status.action.unbookmark" : "settings.swipeactions.status.action.bookmark"
		}
	}

	public func iconName(isBookmarked: Bool = false, privateBoost: Bool = false) -> String {
		switch self {
		case .none:
			return "slash.circle"
		case .bookmark:
			return isBookmarked ? "bookmark.fill" : "bookmark"
		}
	}

	public func color(themeTintColor: Color, useThemeColor: Bool, outside: Bool) -> Color {
		if useThemeColor {
			return outside ? themeTintColor : .gray
		}

		switch self {
		case .none:
			return .gray
		case .bookmark:
			return .pink
		}
	}
}

