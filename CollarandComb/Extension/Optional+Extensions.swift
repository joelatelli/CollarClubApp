//
//  Optional.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/25/23.
//

import Foundation

extension Optional {
	@inlinable var isNil: Bool {
		self == nil
	}

	@inlinable var hasValue: Bool {
		self != nil
	}
}
