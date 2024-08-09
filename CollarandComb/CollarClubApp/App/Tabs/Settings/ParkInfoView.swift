//
//  ParkInfoView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/21/24.
//

import Network
import SwiftUI

@MainActor
struct ParkInfoView: View {
	@Environment(RouterPath.self) private var routerPath
	@Environment(Theme.self) private var theme
	@Environment(Client.self) private var client

//	@State private var dimillianAccount: AccountsListRowViewModel?
//	@State private var iceCubesAccount: AccountsListRowViewModel?

	let versionNumber: String

	init() {
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			versionNumber = version + " "
		} else {
			versionNumber = ""
		}
	}

	var body: some View {
		List {

			Text("Barktastic Rules for Our Exclusive Dog Park Pawty!")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Rule 1: Canine Couture Required 🐩")
				.foregroundColor(theme.tintColor)
				.font(.system(size: 22, weight: .semibold))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.padding(.top, 14)
				.multilineTextAlignment(.leading)

			Text("Dress to impress! Your four-legged friend should flaunt their finest fur attire, and we expect humans to follow suit. If your dog's bowtie doesn't match your ascot, you're doing it wrong.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Rule 2: Yap, Don't Nap 🗣️")
				.foregroundColor(theme.tintColor)
				.font(.system(size: 22, weight: .semibold))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.padding(.top, 14)
				.multilineTextAlignment(.leading)

			Text("This is no place for snoozin'! We want tail-waggin' chatter, not snoring symphonies. Keep the energy high, and the gossip juicier than a bacon-flavored bone.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Spacer()
				.frame(height: 40)
		}
//		.task {
//			await fetchAccounts()
//		}
		.listStyle(.insetGrouped)
		.scrollContentBackground(.hidden)
		.background(theme.primaryBackgroundColor)
		.navigationTitle(Text("Park Rules"))
		.navigationBarTitleDisplayMode(.inline)
		.environment(\.openURL, OpenURLAction { url in
			routerPath.handle(url: url)
		})
	}

	@ViewBuilder
	private var followAccountsSection: some View {
		EmptyView()
		//	if let iceCubesAccount, let dimillianAccount {
		//	  Section {
		//		AccountsListRow(viewModel: iceCubesAccount)
		//		AccountsListRow(viewModel: dimillianAccount)
		//	  }
		//	  .listRowBackground(theme.primaryBackgroundColor)
		//	} else {
		//	  Section {
		//		ProgressView()
		//	  }
		//	  .listRowBackground(theme.primaryBackgroundColor)
		//	}
	}

	private func fetchAccounts() async {
		//	await withThrowingTaskGroup(of: Void.self) { group in
		//	  group.addTask {
		//		let viewModel = try await fetchAccountViewModel(account: "dimillian@mastodon.social")
		//		await MainActor.run {
		//		  dimillianAccount = viewModel
		//		}
		//	  }
		//	  group.addTask {
		//		let viewModel = try await fetchAccountViewModel(account: "icecubesapp@mastodon.online")
		//		await MainActor.run {
		//		  iceCubesAccount = viewModel
		//		}
		//	  }
		//	}
	}

	//  private func fetchAccountViewModel(account: String) async throws -> AccountsListRowViewModel {
	//	let dimillianAccount: Account = try await client.get(endpoint: Accounts.lookup(name: account))
	//	let rel: [Relationship] = try await client.get(endpoint: Accounts.relationships(ids: [dimillianAccount.id]))
	//	return .init(account: dimillianAccount, relationShip: rel.first)
	//  }
}


