//
//  ProductDetailView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Network
import Shimmer
import SwiftUI
import SDWebImageSwiftUI

@MainActor
struct ProductDetailView: View {
	@Environment(Theme.self) private var theme
	@Environment(CurrentAccount.self) private var currentAccount
	@Environment(CurrentUser.self) private var currentUser
	@Environment(StreamWatcher.self) private var watcher
	@Environment(Client.self) private var client
	@Environment(CartManager.self) private var cartManager
	@Environment(RouterPath.self) private var routerPath
	@Environment(\.isCompact) private var isCompact: Bool
	@Environment(UserPreferences.self) private var userPreferences: UserPreferences

	@State private var viewModel: ProductDetailViewModel

	@State private var isLoaded: Bool = false
	@State private var statusHeight: CGFloat = 0

	@State private var count = 1
	@State private var total: Double = 0.0
	@State private var products = [Product]()
	@State private var options = [String]()
	@State private var firstOption = ""
	@State private var secondOption = ""
	@State private var thirdOption = ""

	/// April 4th, 2023: Without explicit focus being set, VoiceOver will skip over a seemingly random number of elements on this screen when pushing in from the main timeline.
	/// By using ``@AccessibilityFocusState`` and setting focus once, we work around this issue.
	@AccessibilityFocusState private var initialFocusBugWorkaround: Bool

	init(statusId: String) {
		_viewModel = .init(wrappedValue: .init(productId: statusId))
	}

	init(status: Product) {
		_viewModel = .init(wrappedValue: .init(product: status))
	}

	init(remoteStatusURL: URL) {
		_viewModel = .init(wrappedValue: .init(remoteStatusURL: remoteStatusURL))
	}

	var body: some View {
		GeometryReader { reader in
			ScrollViewReader { proxy in
				List {

					switch viewModel.state {
					case .loading:
						loadingDetailView

					case let .display(statuses):
						makeStatusesListView(product: statuses[0])
							.background(theme.primaryBackgroundColor)

					case .error:
						errorView
					}
				}
//				.environment(\.defaultMinListRowHeight, 1)
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
				.background(theme.primaryBackgroundColor)
//				.onChange(of: viewModel.scrollToId) { _, newValue in
//					if let newValue {
//						viewModel.scrollToId = nil
//						proxy.scrollTo(newValue, anchor: .top)
//					}
//				}
				.onAppear {
					guard !isLoaded else { return }
					viewModel.client = client
					viewModel.routerPath = routerPath
					viewModel.accountId = currentUser.user?.id?.uuidString
					Task {
//						let result = await viewModel.fetch()
						isLoaded = true
						total = Double(viewModel.product?.price ?? "0.00") ?? 0.00
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
		.toolbar {
			toolbarCart
		}
		.navigationTitle(viewModel.title)
		.navigationBarTitleDisplayMode(.inline)
	}

	private func makeStatusesListView(product: Product) -> some View {
		VStack {
			VStack(alignment: .leading, spacing: 10) {
				WebImage(url: URL(string: product.imageURL))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: UIScreen.screenWidth - 30, height: 350)
					.cornerRadius(8)
					.shadow(radius: 5)
					.clipped()
					.padding(.bottom, 8)

				ModTextView(text: product.name, type: .h4)
					.fixedSize(horizontal: false, vertical: true)
					.padding(.bottom, 10)
					.padding(.top, 10)

				HStack {
					Text("$\(product.price)")
						.font(.system(size: 24, weight: .regular))

					Spacer()

					HStack {

						Button {
							count += 1
							total += Double(product.price) ?? 0.0
//							viewModel.product!.quantity += 1
						} label: {
							Image(systemName: "plus.circle.fill")
								.font(Font.system(size: 30, weight: .ultraLight))
								.foregroundColor(Color.text_primary_color)
						}
						.buttonStyle(.borderless)

						Text("\(count)")

						Button {
							if self.count > 1 {
								count -= 1
								total -= Double(product.price) ?? 0.0
//								viewModel.product!.quantity -= 1
							}
						} label: {
							Image(systemName: "minus.circle.fill")
								.font(Font.system(size: 30, weight: .ultraLight))
								.foregroundColor(Color.text_primary_color)
						}
						.buttonStyle(.borderless)
					}
				}

				Text("\(product.desc)")
					.padding(.bottom, 20)


				coffeeOptions
					.padding(.bottom, 30)

				Button {
					let productX = Product(id: UUID(), name: product.name, price: product.price, desc: product.desc, createdAt: product.createdAt, imageURL: product.imageURL, size: product.size, options: [],
//										   , options: viewModel.product!.options, sizes: viewModel.product!.sizes,
//										   quantity: viewModel.product!.quantity, isMenuItem: viewModel.product!.isMenuItem, 
										   optionOne: viewModel.product!.optionOne, optionTwo: viewModel.product!.optionTwo, optionThree: viewModel.product!.optionThree, optionFour: viewModel.product!.optionFour, optionFive: viewModel.product!.optionFive
//										   , bookmarked: viewModel.product!.bookmarked
//										   , mediaAttachments: viewModel.product!.mediaAttachments, visibility: viewModel.product!.visibility
					)

					let productOrder = ProductOrder(id: UUID(), quantity: count, totalPrice: total, size: "12 oz", product: product)
					self.cartManager.addToCart(product: productOrder)
				} label: {
					HStack(alignment: .center) {
						Spacer()

						if self.count == 1 {
							Text("Add To Cart - $\(product.price)")
								.foregroundColor(Color.text_primary_color)
						} else {
							Text("Add \(self.count) to Cart - $\(String(format: "%.2f", total))")
								.foregroundColor(Color.text_primary_color)
						}

						Spacer()
					}
					.frame(height: 50)
					.background(theme.tintColor)
					.cornerRadius(4)
					.padding(.bottom, 10)
				}
				.buttonStyle(.borderless)

				Spacer()
					.frame(height: 40)
					.listRowSeparator(.hidden)
					.listRowBackground(theme.secondaryBackgroundColor)
					.listRowInsets(.init())

			}
			.padding(.horizontal, 10)
		}
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

	@ToolbarContentBuilder
	private var toolbarCart: some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			HStack {
				Button {
					Task {
						await viewModel.favorite()
					}
				} label: {
					Image(systemName: viewModel.isFavorited ? "bookmark.fill" : "bookmark")
						.foregroundColor(theme.tintColor)
						.frame(minWidth: 20)
						.contentShape(Rectangle())
						.padding(6)
				}

				Button {
					routerPath.navigate(to: .orderDetail(products: cartManager.productOrders))
				} label: {
					CartButton(numberOfProducts: cartManager.products.count)
				}
			}
		}
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

	private var coffeeOptions: some View {
		VStack(alignment: .leading) {
			Text("Select Milk")
				.foregroundColor(Color.text_primary_color)

			FlexibleView(
				data: ["Whole", "Skim", "Táche Pistachio", "Califia Oat", "Califia Almond", "Soy", "2%", "Half & Half", "Heavy Cream"],
				spacing: 10,
				alignment: .leading
			) { option in
				makeOneChipsViewFor(option)
					.onTapGesture {
						if option == firstOption {
//							viewStore.send(.(todoStatus))
							firstOption = ""
							viewModel.product!.optionOne = nil
						} else {
							firstOption = option
							viewModel.product!.optionOne = option
						}
					}
			}
			.padding(.vertical, 10)
			.padding(.bottom, 14)

			Text("Extra Shot?")
				.foregroundColor(Color.text_primary_color)

			FlexibleView(
				data: ["One Extra Shot", "Two Extra Shots", "Three Extra Shots"],
				spacing: 10,
				alignment: .leading
			) { option in
				makeTwoChipsViewFor(option)
					.onTapGesture {
						if option == secondOption {
							secondOption = ""
							viewModel.product!.optionTwo = nil
						} else {
							secondOption = option
							viewModel.product!.optionTwo = option
						}
					}
			}
			.padding(.vertical, 10)

			Text("Sweetener?")
				.foregroundColor(Color.text_primary_color)

			FlexibleView(
				data: ["Simple Syrup", "1 pack white sugar", "1 pack sugar in raw", "1 pack stevia", "1 pack honey", "1 pack splenda"],
				spacing: 10,
				alignment: .leading
			) { option in
				makeThreeChipsViewFor(option)
					.onTapGesture {
						if option == thirdOption {
							thirdOption = ""
							viewModel.product!.optionThree = nil
						} else {
							thirdOption = option
							viewModel.product!.optionThree = option
						}
					}
			}
			.padding(.vertical, 10)

		}
		.listRowBackground(theme.primaryBackgroundColor)
		.listRowSeparator(.hidden)
		.listRowInsets(.init())
//		.frame(height: .layoutPadding)
//		.accessibilityHidden(true)
	}

	@ViewBuilder private func makeOneChipsViewFor(_ filterTag: String) -> some View {

		HStack {

			Text(filterTag)
				.foregroundColor(Color.primary_color)
				.font(.system(size: 14))
//				.font(.system(.subheadline, weight: .bold))
				.lineLimit(2)
				.padding(.horizontal, 5)

		}
		.padding(10)
		.foregroundColor(Color.black)
		.background(firstOption == filterTag ? Color.gold_color : Color.text_primary_color)
		.cornerRadius(4)
	}

	@ViewBuilder private func makeTwoChipsViewFor(_ filterTag: String) -> some View {

		HStack {

			Text(filterTag)
				.foregroundColor(Color.primary_color)
				.font(.system(size: 14))
				.lineLimit(2)
				.padding(.horizontal, 5)

		}
		.padding(10)
		.foregroundColor(Color.black)
		.background(secondOption == filterTag ? Color.gold_color : Color.text_primary_color)
		.cornerRadius(4)
	}

	@ViewBuilder private func makeThreeChipsViewFor(_ filterTag: String) -> some View {

		HStack {
			Text(filterTag)
				.foregroundColor(Color.primary_color)
				.font(.system(size: 14))
				.lineLimit(2)
				.padding(.horizontal, 5)
		}
		.padding(10)
		.foregroundColor(Color.black)
		.background(thirdOption == filterTag ? Color.gold_color : Color.text_primary_color)
		.cornerRadius(4)
	}
}

