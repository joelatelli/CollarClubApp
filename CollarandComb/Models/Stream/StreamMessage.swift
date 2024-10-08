//
//  StreamMessage.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public struct StreamMessage: Encodable {
  public let type: String
  public let stream: String

  public init(type: String, stream: String) {
	self.type = type
	self.stream = stream
  }
}

