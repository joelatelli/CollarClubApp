//
//  InstanceApp.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public struct InstanceApp: Codable, Identifiable {
  public let id: String
  public let name: String
  public let website: URL?
  public let redirectUri: String
  public let clientId: String
  public let clientSecret: String
  public let vapidKey: String?
}

extension InstanceApp: Sendable {}

