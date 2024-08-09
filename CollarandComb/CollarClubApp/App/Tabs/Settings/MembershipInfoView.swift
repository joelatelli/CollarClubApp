//
//  MembershipInfoView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/21/24.
//

import Network
import SwiftUI

@MainActor
struct MembershipInfoView: View {
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

			Text("The Collar Club®, is the worlds the exclusive members only pet social club is destination for pet pampering and luxury services, designed to cater to the diverse needs of pet owners and their beloved companions.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Reserve Guests")
				.foregroundColor(theme.tintColor)
				.font(.system(size: 22, weight: .semibold))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.padding(.top, 14)
				.multilineTextAlignment(.leading)

			Text("Exclusive access to our coffee park on appointment days.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Flexibility to choose the Master Groomer, store location, spa suite, date, and perfect time for your service.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Consistent and reliable guests receive $10 off recurring grooming services. Bookings must be within 5 weeks apart to qualify. Note: Lateness or no-shows will disqualify this offer.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)



			Text("Collar Cartel Membership")
				.foregroundColor(theme.tintColor)
				.font(.system(size: 22, weight: .semibold))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.padding(.top, 14)
				.multilineTextAlignment(.leading)

			Text("Unrestricted access to parks, bar, coffee area, and special events.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("A generous 10% discount on all spa services.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Free educational seminar training sessions.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Free educational seminar training sessions.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Access to exclusive events including Yappy Hour, Wine Up Wednesday, Thirsty Thursday, and Bark & Booze Brunches.")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Text("Invitations to special market-priced private events.")
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
		.navigationTitle(Text("Collar Club Membership Info"))
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

