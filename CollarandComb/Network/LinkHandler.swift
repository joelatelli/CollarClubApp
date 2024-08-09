//
//  LinkHandler.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import RegexBuilder

public struct LinkHandler {
  public let rawLink: String

  public var maxId: String? {
	do {
	  let regex = try Regex("max_id=[0-9]+")
	  if let match = rawLink.firstMatch(of: regex) {
		return match.output.first?.substring?.replacingOccurrences(of: "max_id=", with: "")
	  }
	} catch {
	  return nil
	}
	return nil
  }
}

extension LinkHandler: Sendable {}

