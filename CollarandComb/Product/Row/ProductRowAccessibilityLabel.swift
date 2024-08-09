//
//  ProductRowAccessibilityLabel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

/// A utility that creates a suitable combined accessibility label for a `StatusRowView` that is not focused.
@MainActor
struct ProductRowAccessibilityLabel {
	let viewModel: ProductRowViewModel

	var hasSpoiler: Bool {
		return false
	}

	var isReply: Bool {

		return false
	}

	var isBoost: Bool {
		return false
	}

	var filter: Filter? {
//		guard viewModel.isFiltered else {
			return nil
//		}
//		return viewModel.filter?.filter
	}

	func finalLabel() -> Text {
		Text(viewModel.finalProduct.desc)
	}

	func userNamePreamble() -> Text {
		switch (isReply, isBoost) {
		case (true, false):
			Text("accessibility.status.a-replied-to-\(finalUserDisplayName())") + Text(" ")
		case (_, true):
			Text("accessibility.status.a-boosted-b-\(userDisplayName())-\(finalUserDisplayName())") + Text(", ")
		default:
			Text(userDisplayName()) + Text(", ")
		}
	}

	func userDisplayName() -> String {
		return ""
	}

	func finalUserDisplayName() -> String {
		return ""

	}

	func imageAltText() -> Text {
		return Text("")
//		let descriptions = viewModel.finalProduct.mediaAttachments?
//			.compactMap(\.description)
//
//		if descriptions?.count == 1 {
//			return Text("accessibility.image.alt-text-\(descriptions?[0] ?? "")") + Text(", ")
//		} else if descriptions?.count ?? 0 > 1 {
//			return Text("accessibility.image.alt-text-\(descriptions?[0] ?? "")") + Text(", ") + Text("accessibility.image.alt-text-more.label") + Text(", ")
//		} else if viewModel.finalProduct.mediaAttachments?.isEmpty == false {
//			let differentTypes = Set(viewModel.finalProduct.mediaAttachments?.compactMap(\.localizedTypeDescription) ?? []).sorted()
//			return Text("accessibility.status.contains-media.label-\(ListFormatter.localizedString(byJoining: differentTypes))") + Text(", ")
//		} else {
//			return Text("")
//		}
	}

	func pollText() -> Text {
		return Text("")
	}
}

