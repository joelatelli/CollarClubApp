//
//  ProfileTab.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Network
import Shimmer
import SwiftUI

@MainActor
struct ProfileTab: View {
  @Environment(AppAccountsManager.self) private var appAccount
  @Environment(Theme.self) private var theme
  @Environment(Client.self) private var client
  @Environment(CurrentAccount.self) private var currentAccount
	@Environment(CurrentUser.self) private var currentUser
  @State private var routerPath = RouterPath()
  @State private var scrollToTopSignal: Int = 0
  @Binding var popToRootTab: Tab

  var body: some View {
	NavigationStack(path: $routerPath.path) {
		if let account = currentUser.user {
		AccountDetailView(user: account, scrollToTopSignal: $scrollToTopSignal)
			  .withAppRouter()
			  .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
			  .toolbarBackground(theme.primaryBackgroundColor.opacity(0.50), for: .navigationBar)
			  .id(account.id)

		} else {
			AccountDetailView(user: .placeholder(), scrollToTopSignal: $scrollToTopSignal)
			  .redacted(reason: .placeholder)
			  .allowsHitTesting(false)
		}
	}
	.onChange(of: $popToRootTab.wrappedValue) { _, newValue in
	  if newValue == .profile {
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

