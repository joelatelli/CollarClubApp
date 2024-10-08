//
//  ToolbarTab.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

@MainActor
struct ToolbarTab: ToolbarContent {
  @Environment(\.isSecondaryColumn) private var isSecondaryColumn: Bool
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @Environment(UserPreferences.self) private var userPreferences

  @Binding var routerPath: RouterPath

  var body: some ToolbarContent {
	if !isSecondaryColumn {
	  statusEditorToolbarItem(routerPath: routerPath,
							  visibility: userPreferences.postVisibility)
	  if UIDevice.current.userInterfaceIdiom != .pad ||
		  (UIDevice.current.userInterfaceIdiom == .pad && horizontalSizeClass == .compact) {
		ToolbarItem(placement: .navigationBarLeading) {
			EmptyView()
//		  AppAccountsSelectorView(routerPath: routerPath)
		}
	  }
	}
	if UIDevice.current.userInterfaceIdiom == .pad && horizontalSizeClass == .regular {
	  if (!isSecondaryColumn && !userPreferences.showiPadSecondaryColumn) || isSecondaryColumn {
		SecondaryColumnToolbarItem()
	  }
	}
  }
}

