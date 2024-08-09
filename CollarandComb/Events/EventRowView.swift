//
//  EventRowView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import EmojiText
import Network
import SwiftUI
import SDWebImageSwiftUI

@MainActor
struct EventRowView: View {
	@Environment(Theme.self) private var theme
	@Environment(\.redactionReasons) private var reasons

	let event: Event
	let client: Client
	let routerPath: RouterPath

	var body: some View {
		HStack {
			VStack {
				WebImage(url: URL(string: event.imageString!))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 80, height: 80)
					.cornerRadius(4)

				Spacer()
			}
			.padding(.trailing, 8)

			VStack(alignment: .leading, spacing: 3) {

				Text(event.title)
					.font(.system(size: 18, weight: .semibold))
					 .lineLimit(2)
					 .foregroundColor(theme.tintColor)
					 .multilineTextAlignment(.leading)

				Text(event.desc!)
					.font(.system(size: 16, weight: .regular))
					 .lineLimit(1)
					 .foregroundColor(Color.text_secondary_color)
					 .multilineTextAlignment(.leading)

				HStack(spacing: 10) {

					Text("Sept. 9 at 7:30 PM to 10 PM")
						.font(.system(size: 14, weight: .regular))
						 .lineLimit(1)
						 .foregroundColor(Color.text_primary_color)
						 .multilineTextAlignment(.leading)

					Spacer()

				}

				Spacer()
			}
		}
		.padding(10)
		.onTapGesture {
			if let url = URL(string: event.eventURL) {
				UIApplication.shared.open(url)
			}
		}
		.accessibilityElement(children: .combine)
		.alignmentGuide(.listRowSeparatorLeading) { _ in
			-100
		}
	}

	// MARK: - Accessibility actions

	@ViewBuilder
	private var accessibilityUserActions: some View {
		EmptyView()
//		ForEach(notification.accounts) { account in
//			Button("@\(account.username)") {
//				HapticManager.shared.fireHaptic(.notification(.success))
//				routerPath.navigate(to: .accountDetail(id: account.id))
//			}
//		}
	}
}

