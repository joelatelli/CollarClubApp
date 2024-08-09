//
//  ProductRowView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import EmojiText
import Foundation
import Network
import Shimmer
import SwiftUI
import SDWebImageSwiftUI

@MainActor
struct ProductRowView: View {
	@Environment(\.openWindow) private var openWindow
	@Environment(\.isInCaptureMode) private var isInCaptureMode: Bool
	@Environment(\.redactionReasons) private var reasons
	@Environment(\.isCompact) private var isCompact: Bool
	@Environment(\.accessibilityVoiceOverEnabled) private var accessibilityVoiceOverEnabled
	@Environment(\.isStatusFocused) private var isFocused
	@Environment(\.indentationLevel) private var indentationLevel

	@Environment(QuickLook.self) private var quickLook
	@Environment(Theme.self) private var theme

	@State private var viewModel: ProductRowViewModel
	@State private var showSelectableText: Bool = false

	init(viewModel: ProductRowViewModel) {
		_viewModel = .init(initialValue: viewModel)
	}

	var contextMenu: some View {
		StatusRowContextMenu(viewModel: viewModel, showTextForSelection: $showSelectableText)
	}

	var body: some View {
		HStack(alignment: .center, spacing: 0) {
//			if !(viewModel.finalProduct.mediaAttachments?.isEmpty ?? false) {
//			  HStack {
//				  StatusRowMediaPreviewView(attachments: viewModel.finalProduct.mediaAttachments ?? [],
//										  sensitive: false)
//				if theme.statusDisplayStyle == .compact {
//				  Spacer()
//				}
//			  }
//			  .accessibilityHidden(isFocused == false)
//			  .padding(.vertical, 4)
//			}


//			FeaturedImagePreView(
//				attachment: MediaAttachment(id: UUID().uuidString, type: "image", url: URL(string: "https://images.unsplash.com/photo-1579992357154-faf4bde95b3d?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"), previewUrl: URL(string: "https://images.unsplash.com/photo-1579992357154-faf4bde95b3d?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"), description: "Espresso", meta: nil),
//			  imageMaxHeight: 90,
//			  sensitive: false,
//			  appLayoutWidth: 90,
//			  availableWidth: 90,
//			  availableHeight: 90
//			)
//			.accessibilityElement(children: .ignore)
////			.accessibilityLabel(Self.accessibilityLabel(for: attachments[0]))
//			.accessibilityAddTraits([.isButton, .isImage])
//			.onTapGesture { tabAction(for: 0) }


			WebImage(url: URL(string: viewModel.product.imageURL))
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 90, height: 90)
				.cornerRadius(4)
				.padding(.trailing, 10)

			StatusRowTextView(viewModel: viewModel)

		}
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
						await viewModel.loadAuthorRelationship()
					}
				}
		}
		.swipeActions(edge: .trailing) {
			// The actions associated with the swipes are exposed as custom accessibility actions and there is no way to remove them.
			if !isCompact, accessibilityVoiceOverEnabled == false {
				StatusRowSwipeView(viewModel: viewModel, mode: .trailing)
			}
		}
		.swipeActions(edge: .leading) {
			// The actions associated with the swipes are exposed as custom accessibility actions and there is no way to remove them.
			if !isCompact, accessibilityVoiceOverEnabled == false {
				StatusRowSwipeView(viewModel: viewModel, mode: .leading)
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
			ProductDataControllerProvider.shared.dataController(for: viewModel.finalProduct,
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


