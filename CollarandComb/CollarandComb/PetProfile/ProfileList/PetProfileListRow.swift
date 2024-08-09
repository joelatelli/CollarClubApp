//
//  PetProfileListRow.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Combine
import EmojiText
import Network
import SwiftUI

@MainActor
@Observable class PetProfileListRowViewModel {
	var client: Client?

	var profile: PetProfile
	var relationShip: Relationship?

	public init(profile: PetProfile, relationShip: Relationship? = nil) {
		self.profile = profile
		self.relationShip = relationShip
	}
}

@MainActor
struct PetProfileListRow: View {
	@Environment(Theme.self) private var theme
	@Environment(CurrentAccount.self) private var currentAccount
	@Environment(RouterPath.self) private var routerPath
	@Environment(Client.self) private var client
	@Environment(QuickLook.self) private var quickLook

	@State var viewModel: PetProfileListRowViewModel

	@State private var isEditingRelationshipNote: Bool = false
	@State private var showDeleteConfirmation: Bool = false

	init(viewModel: PetProfileListRowViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		HStack(alignment: .top) {

			ZStack {
			   Circle()
				   .fill(theme.tintColor) // Change the color as desired
				   .frame(width: 45, height: 45)

				Text(String(viewModel.profile.name?.prefix(1) ?? "P"))
					 .font(.system(size: 18))
					 .lineLimit(2)
					 .foregroundColor(Color.text_primary_color)
					 .multilineTextAlignment(.center)
			}
			.padding(.trailing, 6)

			VStack(alignment: .leading) {
				Text(viewModel.profile.name ?? "N/A")
					.font(.system(size: 18, weight: .bold))
					 .lineLimit(2)
					 .foregroundColor(theme.tintColor)
					 .multilineTextAlignment(.center)

				Text(viewModel.profile.breed ?? "N/A")
					 .font(.system(size: 16))
					 .lineLimit(2)
					 .foregroundColor(Color.text_primary_color)
					 .multilineTextAlignment(.center)
			}

			Spacer()

			Image(systemName: "arrow.right")
				.font(Font.system(size: 24, weight: .regular))
				.foregroundColor(theme.tintColor)

		}
		.padding(.bottom, 8)
		.onAppear {
			viewModel.client = client
		}
		.background {
			Color.clear
				.contentShape(Rectangle())
				.onTapGesture {
//					guard !isFocused else { return }
					routerPath.navigate(to: .profileDetail(profile: viewModel.profile))

//					viewModel.navigateToDetail()
				}
		}
		.alignmentGuide(.listRowSeparatorLeading) { _ in
			-100
		}
	}
}

