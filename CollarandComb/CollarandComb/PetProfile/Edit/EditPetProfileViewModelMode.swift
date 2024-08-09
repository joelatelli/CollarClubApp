//
//  EditPetProfileViewModelMode.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/9/24.
//

import SwiftUI
import UIKit

extension EditPetProfileViewModel {
	enum Mode {
		case new
		case edit(profile: PetProfile)

		var isEditing: Bool {
			switch self {
			case .edit:
				return true
			default:
				return false
			}
		}

		var title: LocalizedStringKey {
			switch self {
			case .new:
				return "New Pet Profile"
			case .edit:
				return "Edit Profile"
			}
		}
	}
}
