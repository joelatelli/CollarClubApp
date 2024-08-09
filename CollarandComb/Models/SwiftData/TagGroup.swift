//
//  TagGroup.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model class TagGroup: Equatable {
  var title: String = ""
  var symbolName: String = ""
  var tags: [String] = []
  var creationDate: Date = Date()

  init(title: String, symbolName: String, tags: [String]) {
	self.title = title
	self.symbolName = symbolName
	self.tags = tags
	creationDate = Date()
  }
}
