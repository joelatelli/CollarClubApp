//
//  EventRowView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct EventRowView2: View {

	let store: StoreOf<EventRowFeature>
	@EnvironmentObject var cartManager: CartManager

	private struct ViewState: Equatable {
		let event: Event

		init(state: EventRowFeature.State) {
			event = state.event
		}
	}

	var body: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			HStack {
				VStack {
					WebImage(url: URL(string: viewStore.event.imageString!))
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 80, height: 80)
						.cornerRadius(4)

					Spacer()
				}
				.padding(.trailing, 8)

				VStack(alignment: .leading, spacing: 3) {

					ModTextView(text: viewStore.event.title, type: .subtitle_1, lineLimit: 2).foregroundColor(Color.text_primary_color)

					ModTextView(text: viewStore.event.desc!, type: .caption, lineLimit: 1).foregroundColor(Color.gray)

					HStack(spacing: 10) {
//						Image(systemName: "calendar")
//							.font(Font.system(size: 18, weight: .ultraLight))
						ModTextView(text:  "Sept. 9 at 7:30 PM to 10 PM", type: .body_1).foregroundColor(Color.text_primary_color)
							.lineLimit(1)

						Spacer()

					}

					Spacer()
				}
			}
			.padding(8)
			.onTapGesture {
				if let url = URL(string: viewStore.event.eventURL) {
					 UIApplication.shared.open(url)
				  }
			}
//			.overlay(navigationLink)
		}
	}

//	private var navigationLink: some View {
//		WithViewStore(store) { viewStore in
//			NavigationLink(
//				isActive: viewStore.binding(\.$navigationLinkActive),
//				destination: { productDetailView },
//				label: { EmptyView() }
//			)
//		}
//	}
//
//	private var productDetailView: some View {
//		WithViewStore(store, observe: ViewState.init) { viewStore in
//			ProductDetailView(
//				store: store.scope(
//					state: \.productDetailState!,
//					action: EventRowFeature.Action.productDetailAction
//				)
//			)
//		}
//	}
}



