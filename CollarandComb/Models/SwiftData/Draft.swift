//
//  Draft.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model public class Draft {
  public var content: String = ""
  public var creationDate: Date = Date()

  public init(content: String) {
	self.content = content
	creationDate = Date()
  }
}

