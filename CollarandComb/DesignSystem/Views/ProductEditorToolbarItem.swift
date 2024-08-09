//
//  ProductEditorToolbarItem.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

@MainActor
extension View {
  func statusEditorToolbarItem(routerPath _: RouterPath,
							   visibility: Visibility) -> some ToolbarContent
  {
	StatusEditorToolbarItem(visibility: visibility)
  }
}

@MainActor
extension ToolbarContent {
  func statusEditorToolbarItem(routerPath _: RouterPath,
							   visibility: Visibility) -> some ToolbarContent
  {
	StatusEditorToolbarItem(visibility: visibility)
  }
}

@MainActor
struct StatusEditorToolbarItem: ToolbarContent {
  @Environment(\.openWindow) private var openWindow
  @Environment(RouterPath.self) private var routerPath

  let visibility: Visibility

  init(visibility: Visibility) {
	self.visibility = visibility
  }

  var body: some ToolbarContent {
	ToolbarItem(placement: .navigationBarTrailing) {
	  Button {
		Task { @MainActor in
		  #if targetEnvironment(macCatalyst) || os(visionOS)
			openWindow(value: WindowDestinationEditor.newStatusEditor(visibility: visibility))
		  #else
			routerPath.presentedSheet = .newStatusEditor(visibility: visibility)
			HapticManager.shared.fireHaptic(.buttonPress)
		  #endif
		}
	  } label: {
		Image(systemName: "square.and.pencil")
		  .accessibilityLabel("accessibility.tabs.timeline.new-post.label")
		  .accessibilityInputLabels([
			LocalizedStringKey("accessibility.tabs.timeline.new-post.label"),
			LocalizedStringKey("accessibility.tabs.timeline.new-post.inputLabel1"),
			LocalizedStringKey("accessibility.tabs.timeline.new-post.inputLabel2"),
		  ])
		  .offset(y: -2)
	  }
	}
  }
}

@MainActor
struct SecondaryColumnToolbarItem: ToolbarContent {
  @Environment(\.isSecondaryColumn) private var isSecondaryColumn
  @Environment(UserPreferences.self) private var preferences

  public init() {}

  public var body: some ToolbarContent {
	ToolbarItem(placement: isSecondaryColumn ? .navigationBarLeading : .navigationBarTrailing) {
	  Button {
		withAnimation {
		  preferences.showiPadSecondaryColumn.toggle()
		}
	  } label: {
		Image(systemName: "sidebar.right")
	  }
	}
  }
}

