//
//  StatusRowContextMenu.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import Network
import SwiftUI

@MainActor
struct StatusRowContextMenu: View {
	@Environment(\.displayScale) var displayScale
	@Environment(\.openWindow) var openWindow

	@Environment(Client.self) private var client
	@Environment(SceneDelegate.self) private var sceneDelegate
	@Environment(UserPreferences.self) private var preferences
	@Environment(CurrentAccount.self) private var account
	@Environment(CurrentInstance.self) private var currentInstance
	@Environment(ProductDataController.self) private var statusDataController
	@Environment(QuickLook.self) private var quickLook
	@Environment(Theme.self) private var theme

	var viewModel: ProductRowViewModel
	@Binding var showTextForSelection: Bool

	var boostLabel: some View {

//		if statusDataController.isReblogged {
//			return Label("status.action.unboost", image: "Rocket.fill")
//		}
		return Label("status.action.boost", image: "Rocket")
	}

	var body: some View {
		if !viewModel.isRemote {
			Button { Task {
				SoundEffectManager.shared.playSound(.bookmark)
				HapticManager.shared.fireHaptic(.notification(.success))
				await statusDataController.toggleBookmark(remoteStatus: nil)
			} } label: {
				Label(statusDataController.isBookmarked ? "status.action.unbookmark" : "status.action.bookmark",
					  systemImage: statusDataController.isBookmarked ? "bookmark.fill" : "bookmark")
			}
		}

		Divider()

//		Menu("status.action.share-title") {
//			if let urlString = viewModel.status.url,
//			   let url = URL(string: urlString)
//			{
//				ShareLink(item: url,
//						  subject: Text(viewModel.status.reblog?.account.safeDisplayName ?? viewModel.status.account.safeDisplayName),
//						  message: Text(viewModel.status.reblog?.content.asRawText ?? viewModel.status.content.asRawText))
//				{
//					Label("status.action.share", systemImage: "square.and.arrow.up")
//				}
//
//				ShareLink(item: url) {
//					Label("status.action.share-link", systemImage: "link")
//				}
//
//				Button {
//					let view = HStack {
//						ProductRowView(viewModel: viewModel)
//							.padding(16)
//					}
//						.environment(\.isInCaptureMode, true)
//						.environment(Theme.shared)
//						.environment(preferences)
//						.environment(account)
//						.environment(currentInstance)
//						.environment(SceneDelegate())
//						.environment(quickLook)
//						.environment(viewModel.client)
//						.environment(RouterPath())
//						.preferredColorScheme(Theme.shared.selectedScheme == .dark ? .dark : .light)
//						.foregroundColor(Theme.shared.labelColor)
//						.background(Theme.shared.primaryBackgroundColor)
//						.frame(width: sceneDelegate.windowWidth - 12)
//						.tint(Theme.shared.tintColor)
//					let renderer = ImageRenderer(content: view)
//					renderer.scale = displayScale
//					renderer.isOpaque = false
//					if let image = renderer.uiImage {
//						viewModel.routerPath.presentedSheet = .shareImage(image: image, status: viewModel.status)
//					}
//				} label: {
//					Label("status.action.share-image", systemImage: "photo")
//				}
//			}
//		}

//		if let url = URL(string: viewModel.product.url ?? "") {
//			Button { UIApplication.shared.open(url) } label: {
//				Label("status.action.view-in-browser", systemImage: "safari")
//			}
//		}
	}
}

struct CollarActivityView: UIViewControllerRepresentable {
	let image: Image

	func makeUIViewController(context _: UIViewControllerRepresentableContext<CollarActivityView>) -> UIActivityViewController {
		UIActivityViewController(activityItems: [image], applicationActivities: nil)
	}

	func updateUIViewController(_: UIActivityViewController, context _: UIViewControllerRepresentableContext<CollarActivityView>) {}
}

struct SelectTextView: View {
	@Environment(\.dismiss) private var dismiss
	let content: AttributedString

	var body: some View {
		NavigationStack {
			SelectableText(content: content)
				.padding()
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							dismiss()
						} label: {
							Text("action.done").bold()
						}
					}
				}
				.background(Theme.shared.primaryBackgroundColor)
				.navigationTitle("status.action.select-text")
				.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct SelectableText: UIViewRepresentable {
	let content: AttributedString

	func makeUIView(context _: Context) -> UITextView {
		let attributedText = NSMutableAttributedString(content)
		attributedText.addAttribute(
			.font,
			value: Font.scaledBodyFont,
			range: NSRange(location: 0, length: content.characters.count)
		)

		let textView = UITextView()
		textView.isEditable = false
		textView.attributedText = attributedText
		textView.textColor = UIColor(Color.label)
		textView.backgroundColor = UIColor(Theme.shared.primaryBackgroundColor)
		return textView
	}

	func updateUIView(_: UITextView, context _: Context) {}
	func makeCoordinator() {}
}

