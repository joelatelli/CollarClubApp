//
//  Card.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public struct Card: Codable, Identifiable, Equatable, Hashable {
  public var id: String {
	url
  }

  public let url: String
  public let title: String?
  public let description: String?
  public let type: String
  public let image: URL?
}

extension Card: Sendable {}

