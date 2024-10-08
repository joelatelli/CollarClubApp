//
//  StatusHistory.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public struct StatusHistory: Decodable, Identifiable {
  public var id: String {
	createdAt.asDate.description
  }

  public let content: HTMLString
  public let createdAt: ServerDate
  public let emojis: [Emoji]
}

extension StatusHistory: Sendable {}

