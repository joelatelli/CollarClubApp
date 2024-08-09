//
//  OrderHistoryRowView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/6/24.
//

import EmojiText
import Foundation
import Network
import Shimmer
import SwiftUI
import SDWebImageSwiftUI

@MainActor
struct OrderHistoryRowView: View {
	@Environment(\.openWindow) private var openWindow
	@Environment(\.isInCaptureMode) private var isInCaptureMode: Bool
	@Environment(\.redactionReasons) private var reasons
	@Environment(\.isCompact) private var isCompact: Bool
	@Environment(\.accessibilityVoiceOverEnabled) private var accessibilityVoiceOverEnabled
	@Environment(\.isStatusFocused) private var isFocused
	@Environment(\.indentationLevel) private var indentationLevel

	@Environment(QuickLook.self) private var quickLook
	@Environment(Theme.self) private var theme

	@State private var viewModel: OrderHistoryRowViewModel
	@State private var showSelectableText: Bool = false

	@State var count = 1

	init(viewModel: OrderHistoryRowViewModel) {
		_viewModel = .init(initialValue: viewModel)
	}

	var contextMenu: some View {
		EmptyView()
//		StatusRowContextMenu(viewModel: viewModel, showTextForSelection: $showSelectableText)
	}

	var body: some View {
		VStack(alignment: .center, spacing: 0) {
//			HStack {
//				VStack {
//					WebImage(url: URL(string: viewModel.product.imageURL))
//						.resizable()
//						.aspectRatio(contentMode: .fill)
//						.frame(width: 80, height: 80)
//						.cornerRadius(4)
//
//					Spacer()
//				}
//				.padding(.trailing, 6)
//
//				VStack(alignment: .leading) {
//
//					ModTextView(text: viewModel.product.title, type: .subtitle_1, lineLimit: 2).foregroundColor(Color.text_primary_color)
//
//					ModTextView(text:  viewModel.product.desc, type: .body_1, lineLimit: 1).foregroundColor(Color.gray)
//						.padding(.bottom, 4)
//
//	//				ForEach(product.options ?? [], id: \.self) { string in
//	//					HStack {
//	//						ModTextView(text:  string, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
//	//						Spacer()
//	//					}
//	//				}
//
//					if (viewModel.product.optionOne != nil) {
//						HStack {
//							ModTextView(text: viewModel.product.optionOne!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
//							Spacer()
//						}
//					}
//
//					if (viewModel.product.optionTwo != nil) {
//						HStack {
//							ModTextView(text: viewModel.product.optionTwo!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
//							Spacer()
//						}
//					}
//
//					if (viewModel.product.optionThree != nil) {
//						HStack {
//							ModTextView(text: viewModel.product.optionThree!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
//							Spacer()
//						}
//					}
//
//					Spacer()
//
//					HStack {
//
//						HStack {
//
//							Button {
//								count += 1
//								viewModel.product.quantity += 1
//	//							cartManager.increaseAmount(product: product)
//
//							} label: {
//								Image(systemName: "plus.circle.fill")
//									.font(Font.system(size: 22, weight: .ultraLight))
//									.foregroundColor(Color.text_primary_color)
//							}
//
//							ModTextView(text: "\(viewModel.product.quantity)", type: .body_1, lineLimit: 2).foregroundColor(Color.text_primary_color)
//
//							Button {
//	//							if product.quantity > 1 {
//	//								count -= 1
//	//								product.quantity -= 1
//	//								cartManager.decreaseAmount(product: product) // Update the cart with decreased quantity
//	//							} else if product.quantity == 1 {
//	//								cartManager.removeFromCart(product: product)
//	//							}
//	////							if product.quantity > 1 {
//	////								count -= 1
//	////								product.quantity -= 1
//	////								let new = Product(id: UUID(), title: product.title, price: product.price, desc: product.desc, imageURL: product.imageURL, quantity: product.quantity, isMenuItem: product.isMenuItem)
//	////								product = new
//	////								cartManager.decreaseAmount(old: product, product: new)
//	////							} else if product.quantity == 1 {
//	////								cartManager.removeFromCart(product: product)
//	////							}
//							} label: {
//								if viewModel.product.quantity > 1 {
//									Image(systemName: "minus.circle.fill")
//										.font(Font.system(size: 22, weight: .ultraLight))
//										.foregroundColor(Color.text_primary_color)
//								} else if viewModel.product.quantity == 1 {
//									Image(systemName: "trash")
//										.font(Font.system(size: 22, weight: .ultraLight))
//										.foregroundColor(Color.text_primary_color)
//								}
//							}
//							.buttonStyle(.plain)
//						}
//
//						Spacer()
//						ModTextView(text: "$\(viewModel.product.price.description)", type: .body_1, lineLimit: 1).foregroundColor(Color.gold_color)
//
//					}
//				}
//			}
//			.padding(8)

//			StatusRowTextView(viewModel: viewModel)

		}
		.padding(8)
		.onAppear {
			if !reasons.contains(.placeholder) {
				if !isCompact, viewModel.embeddedStatus == nil {
					Task {
						await viewModel.loadEmbeddedStatus()
					}
				}
			}
		}
		.contextMenu {
			contextMenu
				.onAppear {
					Task {
//						await viewModel.loadAuthorRelationship()
					}
				}
		}
		.swipeActions(edge: .trailing) {
			// The actions associated with the swipes are exposed as custom accessibility actions and there is no way to remove them.
			if !isCompact, accessibilityVoiceOverEnabled == false {
				OrderRowSwipeView(viewModel: viewModel, mode: .trailing)
			}
		}
		.swipeActions(edge: .leading) {
			// The actions associated with the swipes are exposed as custom accessibility actions and there is no way to remove them.
			if !isCompact, accessibilityVoiceOverEnabled == false {
				OrderRowSwipeView(viewModel: viewModel, mode: .leading)
			}
		}
#if os(visionOS)
		.listRowBackground(RoundedRectangle(cornerRadius: 8)
			.foregroundStyle(Material.regular))
		.listRowHoverEffect(.lift)
#else
		.listRowBackground(viewModel.highlightRowColor)
#endif
		.listRowInsets(.init(top: 12,
							 leading: .layoutPadding,
							 bottom: isFocused ? 12 : 6,
							 trailing: .layoutPadding))
		.accessibilityElement(children: isFocused ? .contain : .combine)
//		.accessibilityLabel(isFocused == false && accessibilityVoiceOverEnabled
//							? StatusRowAccessibilityLabel(viewModel: viewModel).finalLabel() : Text(""))
//		.accessibilityHidden(viewModel.filter?.filter.filterAction == .hide)
		.accessibilityAction {
			guard !isFocused else { return }
			viewModel.navigateToDetail()
		}
		.accessibilityActions {
			if !isFocused, viewModel.showActions, accessibilityVoiceOverEnabled {
				accessibilityActions
			}
		}
		.background {
			Color.clear
				.contentShape(Rectangle())
				.onTapGesture {
					guard !isFocused else { return }
					viewModel.navigateToDetail()
				}
		}
		.overlay {
			if viewModel.isLoadingRemoteContent {
				remoteContentLoadingView
			}
		}
		.alert(isPresented: $viewModel.showDeleteAlert, content: {
			Alert(
				title: Text("status.action.delete.confirm.title"),
				message: Text("status.action.delete.confirm.message"),
				primaryButton: .destructive(
					Text("status.action.delete"))
				{
					Task {
						await viewModel.delete()
					}
				},
				secondaryButton: .cancel()
			)
		})
		.alignmentGuide(.listRowSeparatorLeading) { _ in
			-100
		}
//		.sheet(isPresented: $showSelectableText) {
//			let content = viewModel.product.title
//			SelectTextView(content: content)
//		}
		.environment(
			OrderDataControllerProvider.shared.dataController(for: viewModel.finalOrder,
															   client: viewModel.client)
		)
	}

	@ViewBuilder
	private var accessibilityActions: some View {
		// Add reply and quote, which are lost when the swipe actions are removed
		Button("status.action.reply") {
			HapticManager.shared.fireHaptic(.notification(.success))
//			viewModel.routerPath.presentedSheet = .replyToStatusEditor(status: viewModel.status)
		}

//		Button("settings.swipeactions.status.action.quote") {
//			HapticManager.shared.fireHaptic(.notification(.success))
//			viewModel.routerPath.presentedSheet = .quoteStatusEditor(status: viewModel.status)
//		}
//		.disabled(viewModel.product.visibility == .direct || viewModel.product.visibility == .priv)
//
//		if viewModel.finalProduct.mediaAttachments.isEmpty == false {
//			Button("accessibility.status.media-viewer-action.label") {
//				HapticManager.shared.fireHaptic(.notification(.success))
//				let attachments = viewModel.finalStatus.mediaAttachments
//#if targetEnvironment(macCatalyst)
//				openWindow(value: WindowDestinationMedia.mediaViewer(
//					attachments: attachments,
//					selectedAttachment: attachments[0]
//				))
//#else
//				quickLook.prepareFor(selectedMediaAttachment: attachments[0], mediaAttachments: attachments)
//#endif
//			}
//		}
//
//		Button(viewModel.displaySpoiler ? "status.show-more" : "status.show-less") {
//			withAnimation {
//				viewModel.displaySpoiler.toggle()
//			}
//		}
//
//		Button("@\(viewModel.status.account.username)") {
//			HapticManager.shared.fireHaptic(.notification(.success))
//			viewModel.routerPath.navigate(to: .accountDetail(id: viewModel.status.account.id))
//		}
//
//		// Add a reference to the post creator
//		if viewModel.status.account != viewModel.finalStatus.account {
//			Button("@\(viewModel.finalStatus.account.username)") {
//				HapticManager.shared.fireHaptic(.notification(.success))
//				viewModel.routerPath.navigate(to: .accountDetail(id: viewModel.finalStatus.account.id))
//			}
//		}
//
//		// Add in each detected link in the content
//		ForEach(viewModel.finalStatus.content.links) { link in
//			switch link.type {
//			case .url:
//				if UIApplication.shared.canOpenURL(link.url) {
//					Button("accessibility.tabs.timeline.content-link-\(link.title)") {
//						HapticManager.shared.fireHaptic(.notification(.success))
//						_ = viewModel.routerPath.handle(url: link.url)
//					}
//				}
//			case .hashtag:
//				Button("accessibility.tabs.timeline.content-hashtag-\(link.title)") {
//					HapticManager.shared.fireHaptic(.notification(.success))
//					_ = viewModel.routerPath.handle(url: link.url)
//				}
//			case .mention:
//				Button("\(link.title)") {
//					HapticManager.shared.fireHaptic(.notification(.success))
//					_ = viewModel.routerPath.handle(url: link.url)
//				}
//			}
//		}
	}

	private func makeFilterView(filter: Filter) -> some View {
		HStack {
			Text("status.filter.filtered-by-\(filter.title)")
			Button {
				withAnimation {
					viewModel.isFiltered = false
				}
			} label: {
				Text("status.filter.show-anyway")
					.foregroundStyle(theme.tintColor)
			}
			.buttonStyle(.plain)
		}
		.onTapGesture {
			withAnimation {
				viewModel.isFiltered = false
			}
		}
		.accessibilityAction {
			viewModel.isFiltered = false
		}
	}

	private var remoteContentLoadingView: some View {
		ZStack(alignment: .center) {
			VStack {
				Spacer()
				HStack {
					Spacer()
					ProgressView()
					Spacer()
				}
				Spacer()
			}
		}
		.background(Color.black.opacity(0.40))
		.transition(.opacity)
	}
}




