//
//  OrderRowView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import EmojiText
import Foundation
import Network
import Shimmer
import SwiftUI
import SDWebImageSwiftUI

@MainActor
struct ProductOrderRowView: View {
	@Environment(\.openWindow) private var openWindow
	@Environment(\.isInCaptureMode) private var isInCaptureMode: Bool
	@Environment(\.redactionReasons) private var reasons
	@Environment(\.isCompact) private var isCompact: Bool
	@Environment(\.accessibilityVoiceOverEnabled) private var accessibilityVoiceOverEnabled
	@Environment(\.isStatusFocused) private var isFocused
	@Environment(\.indentationLevel) private var indentationLevel

	@Environment(QuickLook.self) private var quickLook
	@Environment(Theme.self) private var theme
	@Environment(CartManager.self) private var cartManager

	@State private var viewModel: ProductOrderRowViewModel
	@State private var showSelectableText: Bool = false

	@State var count = 1
	@State var total: Float = 0.0

	init(viewModel: ProductOrderRowViewModel) {
		_viewModel = .init(initialValue: viewModel)
	}

	var contextMenu: some View {
		EmptyView()
//		StatusRowContextMenu(viewModel: viewModel, showTextForSelection: $showSelectableText)
	}

	var body: some View {
		VStack(alignment: .center, spacing: 0) {
			HStack {
				VStack {
					WebImage(url: URL(string: viewModel.productOrder.product.imageURL))
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 80, height: 80)
						.cornerRadius(4)

					Spacer()
				}
				.padding(.trailing, 6)

				VStack(alignment: .leading) {

					Text(viewModel.productOrder.product.name)

					Text(viewModel.productOrder.product.desc)
						.lineLimit(2)
						.foregroundColor(Color.gray)
						.padding(.bottom, 4)

//					if (viewModel.product.optionOne != nil) {
//						HStack {
//							Text(viewModel.product.optionOne!)
//							Spacer()
//						}
//					}
//
//					if (viewModel.product.optionTwo != nil) {
//						HStack {
//							Text(viewModel.product.optionTwo!)
//							Spacer()
//						}
//					}
//
//					if (viewModel.product.optionThree != nil) {
//						HStack {
//							Text(viewModel.product.optionThree!)
//							Spacer()
//						}
//					}

					Spacer()

					HStack {
						HStack(spacing: 8) {

							Button {
								count += 1
//								viewModel.product.quantity += 1
//								cartManager.increaseAmount(product: viewModel.product) // Update the cart with decreased quantity
							} label: {
								Image(systemName: "plus.circle.fill")
									.font(Font.system(size: 22, weight: .ultraLight))
									.foregroundColor(Color.text_primary_color)
							}
							.buttonStyle(.borderless)

							Text("\(count)")
								.lineLimit(2)

							Button {
								if count > 1 {
									count -= 1
//									viewModel.product.quantity -= 1
//									cartManager.decreaseAmount(product: viewModel.product) // Update the cart with decreased quantity
								} else if count == 1 {
//									cartManager.removeFromCart(product: viewModel.product)
								}
							} label: {
								if count > 1 {
									Image(systemName: "minus.circle.fill")
										.font(Font.system(size: 22, weight: .ultraLight))
										.foregroundColor(Color.text_primary_color)
								} else if count == 1 {
									Image(systemName: "trash")
										.font(Font.system(size: 22, weight: .ultraLight))
										.foregroundColor(Color.text_primary_color)
								}
							}
							.buttonStyle(.borderless)
						}

						Spacer()

						Text("$\((Double(count) * (Double(viewModel.productOrder.product.price) ?? 0.0)).description)")
							.foregroundColor(theme.tintColor)

					}
				}
			}

//			StatusRowTextView(viewModel: viewModel)

		}
		.onAppear {
//			count = viewModel.product.quantity
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
				ProductOrderRowSwipeView(viewModel: viewModel, mode: .trailing)
			}
		}
		.swipeActions(edge: .leading) {
			// The actions associated with the swipes are exposed as custom accessibility actions and there is no way to remove them.
			if !isCompact, accessibilityVoiceOverEnabled == false {
				ProductOrderRowSwipeView(viewModel: viewModel, mode: .leading)
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
//		.environment(
//			ProductDataControllerProvider.shared.dataController(for: viewModel.finalProduct,
//															   client: viewModel.client)
//		)
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



