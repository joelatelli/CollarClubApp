//
//  Visibility.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

extension Visibility {
  static var supportDefault: [Self] {
	[.pub, .priv, .unlisted]
  }

  var iconName: String {
	switch self {
	case .pub:
	  "globe.americas"
	case .unlisted:
	  "lock.open"
	case .priv:
	  "lock"
	case .direct:
	  "tray.full"
	}
  }

  var title: LocalizedStringKey {
	switch self {
	case .pub:
	  "status.visibility.public"
	case .unlisted:
	  "status.visibility.unlisted"
	case .priv:
	  "status.visibility.follower"
	case .direct:
	  "status.visibility.direct"
	}
  }
}

