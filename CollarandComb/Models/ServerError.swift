//
//  ServerError.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public struct ServerError: Decodable, Error {
  public let error: String?
  public var httpCode: Int?
}

extension ServerError: Sendable {}

