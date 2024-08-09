//
//  Streaming.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import Foundation

public enum Streaming: Endpoint {
  case streaming

  public func path() -> String {
	switch self {
	case .streaming:
	  "streaming"
	}
  }

  public func queryItems() -> [URLQueryItem]? {
	switch self {
	default:
	  nil
	}
  }
}

