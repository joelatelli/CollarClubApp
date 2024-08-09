//
//  OrderHistoryListViewModelMode.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/10/24.
//

import SwiftUI
import UIKit

extension OrderHistoryListViewModel {
	enum Mode {
		case user(id: String)
		case all

		var isEditing: Bool {
			switch self {
			case .user:
				return true
			default:
				return false
			}
		}

		var title: LocalizedStringKey {
			switch self {
			case .user:
				return "My Orders"
			case .all:
				return "All Orders"
			}
		}
	}
}
