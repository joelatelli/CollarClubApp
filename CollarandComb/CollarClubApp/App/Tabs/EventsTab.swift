//
//  EventsTab.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Network
import Shimmer
import SwiftUI

@MainActor
struct EventsTab: View {
  @Environment(Theme.self) private var theme
  @Environment(StreamWatcher.self) private var watcher
  @Environment(Client.self) private var client
  @Environment(CurrentAccount.self) private var currentAccount
	@Environment(CurrentUser.self) private var currentUser
  @Environment(AppAccountsManager.self) private var appAccount
  @State private var routerPath = RouterPath()
  @State private var scrollToTopSignal: Int = 0
  @Binding var popToRootTab: Tab

  var body: some View {
	NavigationStack(path: $routerPath.path) {
		EventsListView(scrollToTopSignal: $scrollToTopSignal)
		.withAppRouter()
		.withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
//		.toolbar {
//		  ToolbarTab(routerPath: $routerPath)
//		}
		.toolbarBackground(theme.primaryBackgroundColor.opacity(0.50), for: .navigationBar)
		.id(client.id)
	}
	.onChange(of: $popToRootTab.wrappedValue) { _, newValue in
	  if newValue == .messages {
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
	.withSafariRouter()
	.environment(routerPath)
  }
}

