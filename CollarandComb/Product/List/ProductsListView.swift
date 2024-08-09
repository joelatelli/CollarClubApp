//
//  ProductsListView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Network
import Shimmer
import SwiftUI

@MainActor
struct ProductsListView<Fetcher>: View where Fetcher: ProductsFetcher {
	@Environment(Theme.self) private var theme

	@State private var fetcher: Fetcher
	// Whether this status is on a remote local timeline (many actions are unavailable if so)
	private let isRemote: Bool
	private let routerPath: RouterPath
	private let client: Client

	init(fetcher: Fetcher,
				client: Client,
				routerPath: RouterPath,
				isRemote: Bool = false)
	{
		_fetcher = .init(initialValue: fetcher)
		self.isRemote = isRemote
		self.client = client
		self.routerPath = routerPath
	}

	var body: some View {
		switch fetcher.productsState {
		case .loading:
			ForEach(Product.placeholders()) { product in
				ProductRowView(viewModel: .init(product: product, client: client, routerPath: routerPath))
					.redacted(reason: .placeholder)
					.allowsHitTesting(false)
			}
		case .error:
			ErrorView(title: "status.error.title",
					  message: "status.error.loading.message",
					  buttonTitle: "action.retry")
			{
				Task {
					await fetcher.fetchNewestProducts(pullToRefresh: false)
				}
			}
			.listRowBackground(theme.primaryBackgroundColor)
			.listRowSeparator(.hidden)

		case let .display(products, nextPageState):
			ForEach(products, id: \.id) { product in
				ProductRowView(viewModel: ProductRowViewModel(product: product,
															  client: client,
															  routerPath: routerPath,
															  isRemote: isRemote))
				.onAppear {
					fetcher.productDidAppear(product: product)
				}
				.onDisappear {
					fetcher.productDidDisappear(product: product)
				}
			}
			switch nextPageState {
			case .hasNextPage:
				loadingRow
					.id(UUID().uuidString)
					.onAppear {
						Task {
							await fetcher.fetchNextPage()
						}
					}
			case .loadingNextPage:
				loadingRow
					.id(UUID().uuidString)
			case .none:
				EmptyView()
			}
		}
	}

	private var loadingRow: some View {
		HStack {
			Spacer()
			ProgressView()
			Spacer()
		}
		.padding(.horizontal, .layoutPadding)
		.listRowBackground(theme.primaryBackgroundColor)
	}
}

