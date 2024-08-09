//
//  ProductEditorViewModelMode.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import SwiftUI
import UIKit

extension ProductEditor.ViewModel {
	enum Mode {
		case new(visibility: Visibility)
		case edit(product: Product)
//		case shareExtension(items: [NSItemProvider])

		var isInShareExtension: Bool {
			switch self {
//			case .shareExtension:
//				true
			default:
				false
			}
		}

		var isEditing: Bool {
			switch self {
			case .edit:
				true
			default:
				false
			}
		}

		var replyToStatus: Product? {
			switch self {
			default:
				nil
			}
		}

		var title: LocalizedStringKey {
			switch self {
			case .new:
				"status.editor.mode.new"
			case .edit:
				"status.editor.mode.edit"
			}
		}
	}
}

