//
//  CartOrderView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import Network
import Shimmer
import SwiftUI
import SDWebImageSwiftUI

@MainActor
struct CartOrderListView: View {
	@Environment(Theme.self) private var theme
	@Environment(CurrentAccount.self) private var currentAccount
	@Environment(CurrentUser.self) private var currentUser
	@Environment(StreamWatcher.self) private var watcher
	@Environment(Client.self) private var client
	@Environment(CartManager.self) private var cartManager
	@Environment(RouterPath.self) private var routerPath
	@Environment(\.isCompact) private var isCompact: Bool
	@Environment(UserPreferences.self) private var userPreferences: UserPreferences

	@State private var viewModel: CartOrderListViewModel

	@State private var isLoaded: Bool = false
	@State private var statusHeight: CGFloat = 0

	/// April 4th, 2023: Without explicit focus being set, VoiceOver will skip over a seemingly random number of elements on this screen when pushing in from the main timeline.
	/// By using ``@AccessibilityFocusState`` and setting focus once, we work around this issue.
	@AccessibilityFocusState private var initialFocusBugWorkaround: Bool

	init(orderId: String) {
		_viewModel = .init(wrappedValue: .init(orderId: orderId))
	}

	init(products: [ProductOrder]) {
		_viewModel = .init(wrappedValue: .init(products: products))
	}

	var body: some View {
		GeometryReader { reader in
			ScrollViewReader { proxy in
				List {
					if cartManager.products.count > 0 {

						HStack {
							Text("\(cartManager.products.count) Items")
								.font(.system(size: 18, weight: .bold))

							Spacer()

							Text("Subtotal: $\(cartManager.total)")
								.font(.system(size: 18, weight: .medium))

						}
						.padding()
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())

						Divider()
							.foregroundColor(theme.tintColor)
							.listRowBackground(theme.primaryBackgroundColor)
							.listRowSeparator(.hidden)
							.listRowInsets(EdgeInsets())
							.padding(.all, 14)

						ProductOrdersListView(fetcher: viewModel, client: client, routerPath: routerPath)


						Divider()
							.foregroundColor(theme.tintColor)
							.listRowBackground(theme.primaryBackgroundColor)
							.listRowSeparator(.hidden)
							.listRowInsets(EdgeInsets())
							.padding(.all, 14)

						HStack {
							Text("Subtotal")
								.font(.system(size: 18, weight: .bold))

							Spacer()

							Text("$\(cartManager.total)")
								.font(.system(size: 18, weight: .medium))

						}
						.padding()
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())

						Button {
							cartManager.sendOrder(order: OrderDTO(status: "Pending", paymentMethod: "N/A", customerId: "fbb3940a-91a1-46e4-9a4a-f8cdb170cc04", products: cartManager.productOrdersDTO))
//							cartManager.sendOrder(order: CreateOrderData(id: UUID(), user_id: currentUser.user?.id ?? UUID(), products: cartManager.productData))
						} label: {
							HStack(alignment: .center) {
								Spacer()
								Text("Send Order")
									.foregroundColor(Color.text_primary_color)
								Spacer()
							}
							.frame(height: 50)
							.background(theme.tintColor)
							.cornerRadius(4)
							.padding(.bottom, 10)
						}
						.padding(.top, 30)
						.listRowBackground(theme.primaryBackgroundColor)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets())
						.buttonStyle(.borderless)
						.padding(.horizontal, 10)

					} else {
						VStack(alignment: .center) {
							Spacer()
							Text("Your cart is empty")
							Spacer()
						}
					}
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
			.onChange(of: watcher.latestEvent?.id) {
				guard let lastEvent = watcher.latestEvent else { return }
				viewModel.handleEvent(event: lastEvent, currentAccount: currentAccount.account)
			}
		}
		.navigationTitle(viewModel.title)
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

}


