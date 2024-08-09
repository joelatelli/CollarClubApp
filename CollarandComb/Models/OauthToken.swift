//
//  OauthToken.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public struct OauthToken: Codable, Hashable, Sendable {
  public let accessToken: String
  public let tokenType: String
  public let scope: String
  public let createdAt: Double

  public init(accessToken: String, tokenType: String, scope: String, createdAt: Double) {
	self.accessToken = accessToken
	self.tokenType = tokenType
	self.scope = scope
	self.createdAt = createdAt
  }
}

