//
//  CustomEmojis.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

public enum CustomEmojis: Endpoint {
  case customEmojis

  public func path() -> String {
	switch self {
	case .customEmojis:
	  "custom_emojis"
	}
  }

  public func queryItems() -> [URLQueryItem]? {
	nil
  }
}

