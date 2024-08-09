//
//  AppAccount.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import SwiftUI

struct AppAccount: Codable, Identifiable, Hashable {
  public let server: String
  public var accountName: String?
  public let oauthToken: OauthToken?

  public var key: String {
	if let oauthToken {
	  "\(server):\(oauthToken.createdAt)"
	} else {
	  "\(server):anonymous"
	}
  }

  public var id: String {
	key
  }

  public init(server: String,
			  accountName: String?,
			  oauthToken: OauthToken? = nil)
  {
	self.server = server
	self.accountName = accountName
	self.oauthToken = oauthToken
  }
}

extension AppAccount: Sendable {}

