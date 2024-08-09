//
//  DeviceUtil.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/25/23.
//

import UIKit.UIDevice

enum DeviceUtil {
	static var deviceName: String {
		UIDevice.modelName
	}

	static var fullOSName: String {
		"\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
	}

	static func disableScreenAutoLock() {
		UIApplication.shared.isIdleTimerDisabled = true
	}

	static func enableScreenAutoLock() {
		UIApplication.shared.isIdleTimerDisabled = false
	}

	static var isIpad: Bool {
		UIDevice.current.userInterfaceIdiom == .pad
	}

	static var deviceScreenSize: CGRect {
		UIScreen.main.bounds
	}
}

