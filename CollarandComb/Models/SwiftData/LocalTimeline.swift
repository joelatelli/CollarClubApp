//
//  LocalTimeline.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model public class LocalTimeline {
  public var instance: String = ""
  public var creationDate: Date = Date()

  public init(instance: String) {
	self.instance = instance
	creationDate = Date()
  }
}

