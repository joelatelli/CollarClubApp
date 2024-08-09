//
//  NotificationsName.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import UIKit

extension Notification.Name {
  static let shareSheetClose = NSNotification.Name("shareSheetClose")
  static let refreshTimeline = Notification.Name("refreshTimeline")
  static let homeTimeline = Notification.Name("homeTimeline")
  static let trendingTimeline = Notification.Name("trendingTimeline")
  static let federatedTimeline = Notification.Name("federatedTimeline")
  static let localTimeline = Notification.Name("localTimeline")
}

