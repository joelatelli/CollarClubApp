//
//  EditorFocusState.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import SwiftUI

extension ProductEditor {
  enum EditorFocusState: Hashable {
	case main, followUp(index: UUID)
  }

}

