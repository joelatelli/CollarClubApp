//
//  Marker.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public struct Marker: Codable, Sendable {
  public struct Content: Codable, Sendable {
	public let lastReadId: String
	public let version: Int
	public let updatedAt: ServerDate
  }

  public let notifications: Content?
  public let home: Content?
}

