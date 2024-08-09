//
//  Apps.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public enum Apps: Endpoint {
  case registerApp

  public func path() -> String {
	switch self {
	case .registerApp:
	  "apps"
	}
  }

  public func queryItems() -> [URLQueryItem]? {
	switch self {
	case .registerApp:
	  [
		.init(name: "client_name", value: AppInfo.clientName),
		.init(name: "redirect_uris", value: AppInfo.scheme),
		.init(name: "scopes", value: AppInfo.scopes),
		.init(name: "website", value: AppInfo.weblink),
	  ]
	}
  }
}

