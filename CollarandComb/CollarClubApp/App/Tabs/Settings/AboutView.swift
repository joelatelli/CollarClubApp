//
//  AboutView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Network
import SwiftUI

@MainActor
struct AboutView: View {
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

			Text("Collar & Comb, Boutique: Grooming | Training | Daycare | Coffee | Parks & Rec is the Posh Pooch Paradise")
				.foregroundColor(theme.tintColor)
				.font(.system(size: 22, weight: .semibold))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Step into the world of ultra luxury pet ownership with Collar & Comb®, and The Collar Club® where lavish pet ownership is redefined. Here, we marry the sophistication of a contemporary spa with a serene, joyful, and spotlessly clean environment tailored for your dog's grooming and health needs. Our chic atmosphere, state-of-the-art grooming spa suites, and our exclusive, dog-centric members-only ‘Collar Cartel’ have become the bark of the town. With advanced third-wave grooming techniques, luxurious settings, and a team of highly skilled professionals, we're elevating industry standards.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)
		}
//		.task {
//			await fetchAccounts()
//		}
		.listStyle(.insetGrouped)
		.scrollContentBackground(.hidden)
		.background(theme.primaryBackgroundColor)
		.navigationTitle(Text("About The Collar Club"))
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

struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
			.environment(Theme.shared)
	}
}

