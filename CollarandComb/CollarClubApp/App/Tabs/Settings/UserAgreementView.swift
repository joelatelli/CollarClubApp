//
//  UserAgreement.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/21/24.
//

import Network
import SwiftUI

@MainActor
struct UserAgreementView: View {
	@Environment(RouterPath.self) private var routerPath
	@Environment(Theme.self) private var theme
	@Environment(Client.self) private var client

	let versionNumber: String

	@State private var isChecked = false
	@State private var fullName = ""

	init() {
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			versionNumber = version + " "
		} else {
			versionNumber = ""
		}
	}

	var body: some View {
		List {

			Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ")
				.font(.system(size: 18))
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
				.padding(10)
				.multilineTextAlignment(.leading)

			Button(action: {
				UIApplication.shared.open(URL(string: "https://collarandcomb.dog/pricing-and-services/")!)
			}) {
				Text("Click here to see full agreement")
					.foregroundColor(theme.tintColor)
					.font(.system(size: 18, weight: .regular))
					.listRowBackground(theme.primaryBackgroundColor)
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets())
					.padding(10)
					.padding(.top, 14)
					.multilineTextAlignment(.leading)

			}
			.listRowBackground(theme.primaryBackgroundColor)
			.listRowSeparator(.hidden)
			.listRowInsets(EdgeInsets())


			Spacer()
				.frame(height: 60)
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())


			Toggle(isOn: $isChecked) {
				Text("Check to agree to the following conditions")
					.foregroundColor(theme.tintColor)
					.font(.system(size: 18, weight: .regular))
					.listRowBackground(theme.primaryBackgroundColor)
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets())
					.padding(10)
					.padding(.top, 14)
					.multilineTextAlignment(.leading)
			}
			.toggleStyle(iOSCheckboxToggleStyle())
			.listRowBackground(theme.primaryBackgroundColor)
			.listRowSeparator(.hidden)
			.listRowInsets(EdgeInsets())

			TextField("Enter Your Full Name", text: $fullName)
				.frame(maxHeight: 150)
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())

			if isChecked == true {
				Button {

				} label: {
					HStack(alignment: .center) {
						Spacer()

						Text("Complete")
							.foregroundColor(Color.text_primary_color)

						Spacer()
					}
					.frame(height: 50)
					.background(theme.tintColor)
					.cornerRadius(4)
					.padding(.bottom, 10)
				}
				.buttonStyle(.borderless)
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
			}


			Spacer()
				.frame(height: 40)
				.listRowBackground(theme.primaryBackgroundColor)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
		}
//		.task {
//			await fetchAccounts()
//		}
		.listStyle(.insetGrouped)
		.scrollContentBackground(.hidden)
		.background(theme.primaryBackgroundColor)
		.navigationTitle(Text("User Agreement"))
		.navigationBarTitleDisplayMode(.inline)
		.environment(\.openURL, OpenURLAction { url in
			routerPath.handle(url: url)
		})
	}

	@ViewBuilder
	private var followAccountsSection: some View {
		EmptyView()
	}

	private func fetchAccounts() async {

	}


}

struct iOSCheckboxToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		// 1
		Button(action: {

			// 2
			configuration.isOn.toggle()

		}, label: {
			HStack {
				// 3
				Image(systemName: configuration.isOn ? "checkmark.square" : "square")

				configuration.label
			}
		})
	}
}
