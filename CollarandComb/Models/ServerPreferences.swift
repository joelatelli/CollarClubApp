//
//  ServerPreferences.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import SwiftUI

struct ServerPreferences: Decodable {
	let postVisibility: Visibility?
	let postIsSensitive: Bool?
	let postLanguage: String?
	let autoExpandMedia: AutoExpandMedia?
	let autoExpandSpoilers: Bool?

	enum AutoExpandMedia: String, Decodable, CaseIterable {
		case showAll = "show_all"
		case hideAll = "hide_all"
		case hideSensitive = "default"

		var description: LocalizedStringKey {
			switch self {
			case .showAll:
				"enum.expand-media.show"
			case .hideAll:
				"enum.expand-media.hide"
			case .hideSensitive:
				"enum.expand-media.hide-sensitive"
			}
		}
	}

	enum CodingKeys: String, CodingKey {
		case postVisibility = "posting:default:visibility"
		case postIsSensitive = "posting:default:sensitive"
		case postLanguage = "posting:default:language"
		case autoExpandMedia = "reading:expand:media"
		case autoExpandSpoilers = "reading:expand:spoilers"
	}
}

extension ServerPreferences: Sendable {}
extension ServerPreferences.AutoExpandMedia: Sendable {}

