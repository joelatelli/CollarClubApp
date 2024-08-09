//
//  CollarAndCombTab.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Network
import Shimmer
import SwiftUI

@MainActor
struct CollarAndCombTab: View {
  @Environment(Theme.self) private var theme
  @Environment(UserPreferences.self) private var preferences
  @Environment(CurrentAccount.self) private var currentAccount
  @Environment(Client.self) private var client
  @State private var routerPath = RouterPath()
  @State private var scrollToTopSignal: Int = 0
  @Binding var popToRootTab: Tab

  var body: some View {
	NavigationStack(path: $routerPath.path) {
		EmptyView()
//	  ExploreView(scrollToTopSignal: $scrollToTopSignal)
//		.withAppRouter()
//		.withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
//		.toolbarBackground(theme.primaryBackgroundColor.opacity(0.50), for: .navigationBar)
//		.toolbar {
//		  ToolbarTab(routerPath: $routerPath)
//		}
	}
	.withSafariRouter()
	.environment(routerPath)
	.onChange(of: $popToRootTab.wrappedValue) { _, newValue in
	  if newValue == .explore {
		if routerPath.path.isEmpty {
		  scrollToTopSignal += 1
		} else {
		  routerPath.path = []
		}
	  }
	}
	.onChange(of: client.id) {
	  routerPath.path = []
	}
	.onAppear {
	  routerPath.client = client
	}
  }
}

