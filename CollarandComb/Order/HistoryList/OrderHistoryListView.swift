//
//  OrderHistoryListView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/6/24.
//

import Network
import Shimmer
import SwiftUI
import SDWebImageSwiftUI

@MainActor
struct OrderHistoryListView: View {
	@Environment(Theme.self) private var theme
	@Environment(CurrentAccount.self) private var currentAccount
	@Environment(StreamWatcher.self) private var watcher
	@Environment(Client.self) private var client
	@Environment(CartManager.self) private var cartManager
	@Environment(RouterPath.self) private var routerPath
	@Environment(\.isCompact) private var isCompact: Bool
	@Environment(UserPreferences.self) private var userPreferences: UserPreferences

	@State private var viewModel: OrderHistoryListViewModel

	@State private var isLoaded: Bool = false
	@State private var statusHeight: CGFloat = 0

	/// April 4th, 2023: Without explicit focus being set, VoiceOver will skip over a seemingly random number of elements on this screen when pushing in from the main timeline.
	/// By using ``@AccessibilityFocusState`` and setting focus once, we work around this issue.
	@AccessibilityFocusState private var initialFocusBugWorkaround: Bool

	init(mode: OrderHistoryListViewModel.Mode){
		_viewModel = .init(initialValue: .init(mode: mode))
	}

	var body: some View {
		GeometryReader { reader in
			ScrollViewReader { proxy in
				List {
					OrdersListView(fetcher: viewModel, client: client, routerPath: routerPath)
				}
				.environment(\.defaultMinListRowHeight, 1)
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
				.background(theme.primaryBackgroundColor)
				.onChange(of: viewModel.scrollToId) { _, newValue in
					if let newValue {
						viewModel.scrollToId = nil
						proxy.scrollTo(newValue, anchor: .top)
					}
				}
				.onAppear {
					guard !isLoaded else { return }
					viewModel.client = client
					viewModel.routerPath = routerPath
					Task {
						let result = await viewModel.fetch()
						isLoaded = true

//						if !result {
//							if let url = viewModel.remoteStatusURL {
//								await UIApplication.shared.open(url)
//							}
//							DispatchQueue.main.async {
//								_ = routerPath.path.popLast()
//							}
//						}
					}
				}
			}
			.refreshable {
				Task {
					await viewModel.fetch()
				}
			}
			.onChange(of: watcher.latestEvent?.id) {
				guard let lastEvent = watcher.latestEvent else { return }
				viewModel.handleEvent(event: lastEvent, currentAccount: currentAccount.account)
			}
		}
		.toolbar {
			toolbarTitleView
			toolbarCart
		}
		.navigationBarTitleDisplayMode(.inline)
	}

	private var errorView: some View {
		ErrorView(title: "status.error.title",
				  message: "status.error.message",
				  buttonTitle: "action.retry")
		{
			Task {
				await viewModel.fetch()
			}
		}
		.listRowBackground(theme.primaryBackgroundColor)
		.listRowSeparator(.hidden)
	}

	private var loadingDetailView: some View {
		ForEach(Product.placeholders()) { product in
			ProductRowView(viewModel: .init(product: product, client: client, routerPath: routerPath))
				.redacted(reason: .placeholder)
				.allowsHitTesting(false)
		}
	}

	private var loadingContextView: some View {
		HStack {
			Spacer()
			ProgressView()
			Spacer()
		}
		.frame(height: 50)
		.listRowSeparator(.hidden)
		.listRowBackground(theme.secondaryBackgroundColor)
		.listRowInsets(.init())
	}

	private var topPaddingView: some View {
		HStack { EmptyView() }
			.listRowBackground(theme.primaryBackgroundColor)
			.listRowSeparator(.hidden)
			.listRowInsets(.init())
			.frame(height: .layoutPadding)
			.accessibilityHidden(true)
	}

	@ToolbarContentBuilder
	private var toolbarTitleView: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			VStack(alignment: .center) {
				Text(viewModel.mode.title)
			}
			.accessibilityRepresentation {
				Text(viewModel.mode.title)
			}
			.accessibilityAddTraits(.isHeader)
			.accessibilityRemoveTraits(.isButton)
//			.accessibilityRespondsToUserInteraction(canFilterTimeline)
		}
	}

	@ToolbarContentBuilder
	private var toolbarCart: some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			Button {
				routerPath.navigate(to: .orderDetail(products: cartManager.productOrders))
			} label: {
				CartButton(numberOfProducts: cartManager.products.count)
			}
		}
	}

}



