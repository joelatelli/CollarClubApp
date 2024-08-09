//
//  PetProfileDetailView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/31/23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct PetProfileDetailView2: View {
	let store: StoreOf<PetProfileDetailFeature>

	@EnvironmentObject var cartManager: CartManager
	@EnvironmentObject private var userVM: UserViewModel

	@State var count = 1
	@State var total: Float = 0
	@State var products = [Product]()
	@State var options = [String]()
	@State var confirmProfileDelete = false

	@State private var showAddSheet = false

	private struct ViewState: Equatable {
		var profile: PetProfile
		var count = 0
		var total: Float = 0

		init(state: PetProfileDetailFeature.State) {
			profile = state.profile
			count = state.count
			total = state.total
		}
	}

	var body: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			ZStack {
				BigGradient()
						.ignoresSafeArea()
				ScrollView {

					VStack(alignment: .leading, spacing: 10) {

						ModTextView(text: viewStore.profile.name ?? "N/A", type: .h4, lineLimit: 6).foregroundColor(Color.gold_color)
							.padding(.vertical, 20)

						questionsView
							.padding(.bottom, 30)


						Spacer()
							.frame(height: 50)
					}

				}
				.padding(.horizontal, 14)
				.alert(isPresented: $confirmProfileDelete,
						content: {
					Alert(title: Text(viewStore.profile.name ?? "Delete Profile"), message: Text("Are you sure you want to delete this profile?"),
						 primaryButton: .destructive(Text("Delete")) {
						 viewStore.send(.deleteProfile, animation: .easeInOut)
						confirmProfileDelete = false
						 }, secondaryButton: Alert.Button.cancel(Text("Cancel"), action: { confirmProfileDelete = false })
					 )
				 })
				.fullScreenCover(isPresented: $showAddSheet) {
					PetProfileSheet(
					store: store.scope(
						   state: \.addSheetState,
						   action: PetProfileDetailFeature.Action.addPetProfileSheetAction
					   )
					)
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Pet Profile")
		.toolbar(content: toolbar)
	}

	private var questionsView: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			VStack(alignment: .leading) {

				HStack { ModTextView(text: "Age of pet".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
					.padding(.top, 15)

				HStack { ModTextView(text: viewStore.profile.age ?? "n/a", type: .body_1).foregroundColor(Color.text_primary_color); Spacer() }
					.padding(.top, 8)

				HStack { ModTextView(text: "Breed of your dog...".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
					.padding(.top, 15)

				HStack { ModTextView(text: viewStore.profile.breed ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
					.padding(.top, 8)

				HStack { ModTextView(text: "How much does your dog weigh?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
					.padding(.top, 15)

				HStack { ModTextView(text: viewStore.profile.weight ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
					.padding(.top, 8)

				questionsView2
			}
		}
	}

	private var questionsView2: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			VStack(alignment: .leading) {

				HStack { ModTextView(text: "Whats the temperment of your dog?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
					.padding(.top, 15)
				HStack { ModTextView(text: viewStore.profile.temperment ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
					.padding(.top, 8)

				HStack { ModTextView(text: "Does your dog have any special needs?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
					.padding(.top, 15)
				HStack { ModTextView(text: viewStore.profile.specialNeeds ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
					.padding(.top, 8)

				HStack { ModTextView(text: "Is your dog vaccinated (and When)?".uppercased(), type: .overline).foregroundColor(Color.gold_color); Spacer() }
					.padding(.top, 15)
				HStack { ModTextView(text: viewStore.profile.lastVaccinated ?? "n/a", type: .body_1).foregroundColor(Color.white); Spacer() }
					.padding(.top, 8)
			}
		}
	}
}

extension PetProfileDetailView2 {
	private func toolbar() -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			WithViewStore(store) { viewStore in
				HStack(spacing: 6) {
					Image(systemName: "trash")
						.foregroundColor(.text_primary_color)
						.frame(minWidth: 20)
						.contentShape(Rectangle())
						.padding(6)
						.onTapGesture {
							confirmProfileDelete.toggle()
						}

					Image(systemName: "pencil.circle")
						.foregroundColor(.text_primary_color)
						.frame(minWidth: 20)
						.contentShape(Rectangle())
						.padding(6)
						.onTapGesture {
							showAddSheet.toggle()
						}
				}
			}
		}
	}
}

