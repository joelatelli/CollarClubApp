//
//  PetProfileRow.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/31/23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct PetProfileRow: View {

	let store: StoreOf<PetProfileRowFeature>
	@EnvironmentObject var cartManager: CartManager

	private struct ViewState: Equatable {
		let profile: PetProfile

		init(state: PetProfileRowFeature.State) {
			profile = state.profile
		}
	}

	var body: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			HStack {
//				Image("footprint")
//					.resizable()
//					.scaledToFit()
//					.frame(height: 35)
////					.padding(.trailing, 20)
//					.background(Color.primary_color)
//					.padding(.trailing, 4)

				ZStack {
				   Circle()
					   .fill(Color.gold_color) // Change the color as desired
					   .frame(width: 35, height: 35)

					ModTextView(text: String(viewStore.profile.name?.prefix(1) ?? "P"), type: .subtitle_1B, lineLimit: 2).foregroundColor(Color.text_primary_color)

				}
				.padding(.trailing, 6)

				VStack(alignment: .leading) {
					ModTextView(text: viewStore.profile.name ?? "N/A", type: .subtitle_1B, lineLimit: 2).foregroundColor(Color.gold_color)
					ModTextView(text: viewStore.profile.breed ?? "N/A", type: .body_1, lineLimit: 2).foregroundColor(Color.text_primary_color)
				}

				Spacer()

				Image(systemName: "arrow.right")
					.font(Font.system(size: 30, weight: .ultraLight))
				
			}
			.padding(.bottom, 8)
//			.padding(20)
//			.background(Color.secondary_color)
//			.cornerRadius(4)
			.onTapGesture {
				ViewStore(store).binding(\.$navigationLinkActive).wrappedValue.toggle()
			}
			.overlay(navigationLink)
		}
	}

	private var navigationLink: some View {
		WithViewStore(store) { viewStore in
			NavigationLink(
				isActive: viewStore.binding(\.$navigationLinkActive),
				destination: { profileDetailView },
				label: { EmptyView() }
			)
		}
	}

	private var profileDetailView: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			PetProfileDetailView2(
				store: store.scope(
					state: \.profileDetailState!,
					action: PetProfileRowFeature.Action.profileDetailAction
				)
			)
		}
	}
}



