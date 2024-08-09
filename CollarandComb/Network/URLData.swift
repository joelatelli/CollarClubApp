//
//  URLData.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

extension Data {
  func base64UrlEncodedString() -> String {
	base64EncodedString()
	  .replacingOccurrences(of: "+", with: "-")
	  .replacingOccurrences(of: "/", with: "_")
	  .replacingOccurrences(of: "=", with: "")
  }
}

