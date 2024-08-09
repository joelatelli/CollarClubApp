//
//  OffsetKey.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/16/23.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
	static var defaultValue: CGRect = .zero

	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}
