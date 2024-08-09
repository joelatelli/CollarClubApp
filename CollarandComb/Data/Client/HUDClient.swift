//
//  HUDClient.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/15/23.
//

import SwiftUI
import ComposableArchitecture

extension DependencyValues {
	var hudClient: HUDClient {
		get { self[HUDClient.self] }
		set { self[HUDClient.self] = newValue }
	}
}

final class HUDClient: ObservableObject, DependencyKey {
	@Published var isPresented = false
	private(set) var message = ""
	private(set) var iconName: String?
	private(set) var backgroundColor: Color = Color.main_color
	private var workItem: DispatchWorkItem?

	static let liveValue = HUDClient()

	private init () { }

	func show(message: String, iconName: String? = nil, hideAfter: Double = 3.5, backgroundColor: Color = Color.main_color) {
		self.message = message
		self.iconName = iconName
		self.backgroundColor = backgroundColor

		withAnimation {
			isPresented = true
		}

		workItem?.cancel()

		workItem = DispatchWorkItem {
			withAnimation {
				self.isPresented = false
			}
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + hideAfter, execute: workItem!)
	}
}

