//
//  ProductTimelineListViewModel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/6/24.
//

import Network
import Observation
import SwiftUI
import Combine

enum ProductTimelineListViewModelMode {
  case saved(accountId: String)

  var title: LocalizedStringKey {
	switch self {
	case .saved:
	  "Saved Products"
	}
  }
}


@MainActor
@Observable class ProductTimelineListViewModel {
	let mode: ProductTimelineListViewModelMode

	var scrollToIndex: Int?
	var productsState: ProductsState = .loading
	var timeline: TimelineFilter = .federated {
		willSet {
			if timeline == .home && newValue != .resume {
				saveMarker()
			}
		}
		didSet {
			timelineTask?.cancel()
			timelineTask = Task {
				await handleLatestOrResume(oldValue)

				if oldValue != timeline {
					await reset()
					pendingStatusesObserver.pendingStatuses = []
					tag = nil
				}

				guard !Task.isCancelled else {
					return
				}

				await fetchNewestProducts(pullToRefresh: false)
				switch timeline {
				case let .hashtag(tag, _):
					await fetchTag(id: tag)
				default:
					break
				}
			}
		}
	}

	private var cancellables: Set<AnyCancellable> = []

	private(set) var timelineTask: Task<Void, Never>?

	var tag: Tag?

	// Internal source of truth for a timeline.
	private(set) var datasource = TimelineDatasource()
	private let cache = TimelineCache()
	private var isCacheEnabled: Bool {
		canFilterTimeline && timeline.supportNewestPagination
	}

	@ObservationIgnored
	private var visibileStatuses: [Product] = []

	var products: [Product] = []

	var limit: Int?
	var total: Int?
	var page: Int = 1

	var hasMoreData: Bool {
	   guard let limit = limit, let total = total else {
		   return true
	   }
	   return products.count < total && products.count < limit * page
	}

	private var canStreamEvents: Bool = true {
		didSet {
			if canStreamEvents {
				pendingStatusesObserver.isLoadingNewStatuses = false
			}
		}
	}

	@ObservationIgnored
	var canFilterTimeline: Bool = true

	var client: Client? {
		didSet {
			if oldValue != client {
				Task {
					await reset()
				}
			}
		}
	}

	var scrollToTopVisible: Bool = false {
		didSet {
			if scrollToTopVisible {
				pendingStatusesObserver.pendingStatuses = []
			}
		}
	}

	var serverName: String {
		client?.server ?? "Error"
	}

	var isTimelineVisible: Bool = false
	let pendingStatusesObserver: TimelineUnreadStatusesObserver = .init()
	var scrollToIndexAnimated: Bool = false
	var marker: Marker.Content?

	init(mode: ProductTimelineListViewModelMode) {
		self.mode = mode

		pendingStatusesObserver.scrollToIndex = { [weak self] index in
			self?.scrollToIndexAnimated = true
			self?.scrollToIndex = index
		}
	}

	private func fetchTag(id: String) async {
//		guard let client else { return }
//		do {
//			let tag: Tag = try await client.get(endpoint: Tags.tag(id: id))
//			withAnimation {
//				self.tag = tag
//			}
//		} catch {}
	}

	func reset() async {
		await datasource.reset()
	}

	private func handleLatestOrResume(_ oldValue: TimelineFilter) async {
		if timeline == .latest || timeline == .resume {
			await clearCache(filter: oldValue)
			if timeline == .resume, let marker = await fetchMarker() {
				self.marker = marker
			}
			timeline = oldValue
		}
	}

	func handleEvent(event: any StreamEvent) async {
//		if let event = event as? StreamEventUpdate,
//		   let client,
//		   timeline == .home,
//		   canStreamEvents,
//		   isTimelineVisible,
//		   await !datasource.contains(statusId: event.status.id)
//		{
//			pendingStatusesObserver.pendingStatuses.insert(event.status.id, at: 0)
//			let newStatus = event.status
//			await datasource.insert(newStatus, at: 0)
//			await cache()
//			ProductDataControllerProvider.shared.updateDataControllers(for: [event.status], client: client)
//			let statuses = await datasource.getFiltered()
//			withAnimation {
//				statusesState = .display(statuses: statuses, nextPageState: .hasNextPage)
//			}
//		} else if let event = event as? StreamEventDelete {
//			await datasource.remove(event.status)
//			await cache()
//			let statuses = await datasource.getFiltered()
//			withAnimation {
//				statusesState = .display(statuses: statuses, nextPageState: .hasNextPage)
//			}
//		} else if let event = event as? StreamEventStatusUpdate, let client {
//			if let originalIndex = await datasource.indexOf(statusId: event.status.id) {
//				ProductDataControllerProvider.shared.updateDataControllers(for: [event.status], client: client)
//				await datasource.replace(event.status, at: originalIndex)
//				await cache()
//				let statuses = await datasource.getFiltered()
//				statusesState = .display(statuses: statuses, nextPageState: .hasNextPage)
//			}
//		}
	}
}

// MARK: - Cache

extension ProductTimelineListViewModel {
	private func cache() async {
		if let client, isCacheEnabled {
			await cache.set(statuses: datasource.get(), client: client.id, filter: timeline.id)
		}
	}

	private func getCachedStatuses() async -> [Product]? {
		if let client, isCacheEnabled {
			return await cache.getStatuses(for: client.id, filter: timeline.id)
		}
		return nil
	}

	private func clearCache(filter: TimelineFilter) async {
		if let client, isCacheEnabled {
			await cache.clearCache(for: client.id, filter: filter.id)
			await cache.setLatestSeenStatuses([], for: client, filter: filter.id)
		}
	}
}

// MARK: - StatusesFetcher

extension ProductTimelineListViewModel: ProductsFetcher {

	func pullToRefresh() async {
		timelineTask?.cancel()
		if !timeline.supportNewestPagination || UserPreferences.shared.fastRefreshEnabled {
			await reset()
		}
		await fetchNewestProducts(pullToRefresh: true)
	}

	func refreshTimeline() {
		timelineTask?.cancel()
		timelineTask = Task {
			if UserPreferences.shared.fastRefreshEnabled {
				await reset()
			}
			await fetchNewestProducts(pullToRefresh: false)
		}
	}

	func refreshTimelineContentFilter() async {
		timelineTask?.cancel()
		let statuses = await datasource.getFiltered()
		withAnimation {
			productsState = .display(products: statuses, nextPageState: .hasNextPage)
		}
	}

	func fetchProducts(from: Marker.Content) async throws {
		guard let client else { return }
		productsState = .loading
		var statuses: [Product] = try await client.get(endpoint: timeline.endpoint(sinceId: nil,
																				  maxId: from.lastReadId,
																				  minId: nil,
																				  offset: 0))

		ProductDataControllerProvider.shared.updateDataControllers(for: statuses, client: client)

		await datasource.set(statuses)
		await cache()
		statuses = await datasource.getFiltered()
		marker = nil

		withAnimation {
			productsState = .display(products: statuses, nextPageState: .hasNextPage)
		}

		await fetchNewestProducts(pullToRefresh: false)
	}

	func fetchNewestProducts(pullToRefresh: Bool) async {
		guard let client else { return }

		let endpoint = Products.fetchAll(limit: limit ?? 20, page: page)  // Choose the appropriate endpoint
		let token = Auth().token ?? "GFYKboKQcideGm23UAvEOA=="

		let url = client.makeKaizenURL(endpoint: endpoint)

//		client.get(url: url, token: token, decodeResponseAs: ResponseData<[Product]>.self)
//			.sink { completion in
//				switch completion {
//				case .finished:
//					break
//				case .failure(let error):
//					// Handle the error here
//					print("Product LIST Error: \(error)")
//				}
//			} receiveValue: { [weak self] response in
//				// Perform any further processing if needed
//				self?.products = response.data
//
//				self?.limit = response.limit
//				self?.total = response.total
//				self!.page += 1
//
//				self!.productsState = .display(products: self!.products, nextPageState: self?.hasMoreData ?? true ? .hasNextPage : .none)
//			}
//			.store(in: &self.cancellables)
	}

	// Hydrate statuses in the Timeline when statuses are empty.
	private func fetchFirstPage(client: Client) async throws {
		pendingStatusesObserver.pendingStatuses = []

		if await datasource.isEmpty {
			productsState = .loading
		}

		// If we get statuses from the cache for the home timeline, we displays those.
		// Else we fetch top most page from the API.
		if timeline.supportNewestPagination,
		   let cachedProducts = await getCachedStatuses(),
		   !cachedProducts.isEmpty,
		   !UserPreferences.shared.fastRefreshEnabled
		{
			await datasource.set(cachedProducts)
			let statuses = await datasource.getFiltered()
			if let latestSeenId = await cache.getLatestSeenStatus(for: client, filter: timeline.id)?.first,
			   let index = await datasource.indexOf(statusId: latestSeenId),
			   index > 0
			{
				// Restore cache and scroll to latest seen status.
				productsState = .display(products: statuses, nextPageState: .hasNextPage)
				scrollToIndexAnimated = false
				scrollToIndex = index + 1
			} else {
				// Restore cache and scroll to top.
				withAnimation {
					productsState = .display(products: statuses, nextPageState: .hasNextPage)
				}
			}
			// And then we fetch statuses again toget newest statuses from there.
			await fetchNewestProducts(pullToRefresh: false)
		} else {
			var statuses: [Product] = try await client.get(endpoint: timeline.endpoint(sinceId: nil,
																					  maxId: nil,
																					  minId: nil,
																					  offset: 0))

			ProductDataControllerProvider.shared.updateDataControllers(for: statuses, client: client)

			await datasource.set(statuses)
			await cache()
			statuses = await datasource.getFiltered()

			withAnimation {
				productsState = .display(products: statuses, nextPageState: statuses.count < 20 ? .none : .hasNextPage)
			}
		}
	}

	// Fetch pages from the top most status of the tomeline.
	private func fetchNewPagesFrom(latestStatus: String, client: Client) async throws {
		canStreamEvents = false
		let initialTimeline = timeline
		var newProducts: [Product] = await fetchNewPages(minId: latestStatus, maxPages: 5)

		// Dedup statuses, a status with the same id could have been streamed in.
		let ids = await datasource.get().map(\.id)
		newProducts = newProducts.filter { status in
			!ids.contains(where: { $0 == status.id })
		}

		ProductDataControllerProvider.shared.updateDataControllers(for: newProducts, client: client)

		// If no new statuses, resume streaming and exit.
		guard !newProducts.isEmpty else {
			canStreamEvents = true
			return
		}

		// If the timeline is not visible, we don't update it as it would mess up the user position.
		guard isTimelineVisible else {
			canStreamEvents = true
			return
		}

		// Return if task has been cancelled.
		guard !Task.isCancelled else {
			canStreamEvents = true
			return
		}

		// As this is a long runnign task we need to ensure that the user didn't changed the timeline filter.
		guard initialTimeline == timeline else {
			canStreamEvents = true
			return
		}

		// Keep track of the top most status, so we can scroll back to it after view update.
		let topProduct = await datasource.getFiltered().first

		// Insert new statuses in internal datasource.
		await datasource.insert(contentOf: newProducts, at: 0)

		// Cache statuses for timeline.
		await cache()

		// Append new statuses in the timeline indicator.
		pendingStatusesObserver.pendingStatuses.insert(contentsOf: newProducts.map(\.id!.uuidString), at: 0)

		// High chance the user is scrolled to the top.
		// We need to update the statuses state, and then scroll to the previous top most status.
		if let topProduct, visibileStatuses.contains(where: { $0.id == topProduct.id}), scrollToTopVisible {
			pendingStatusesObserver.disableUpdate = true
			let statuses = await datasource.getFiltered()
			productsState = .display(products: statuses,
									 nextPageState: statuses.count < 20 ? .none : .hasNextPage)
			scrollToIndexAnimated = false
			scrollToIndex = newProducts.count + 1
			DispatchQueue.main.async {
				self.pendingStatusesObserver.disableUpdate = false
				self.canStreamEvents = true
			}
		} else {
			// This will keep the scroll position (if the list is scrolled) and prepend statuses on the top.
			let statuses = await datasource.getFiltered()
			withAnimation {
				productsState = .display(products: statuses,
										 nextPageState: statuses.count < 20 ? .none : .hasNextPage)
				canStreamEvents = true
			}
		}

		// We trigger a new fetch so we can get the next new statuses if any.
		// If none, it'll stop there.
		// Only do that in the context of the home timeline as other don't worth catching up that much.
		if timeline == .home,
		   !Task.isCancelled,
		   let latest = await datasource.get().first
		{
			pendingStatusesObserver.isLoadingNewStatuses = true
			try await fetchNewPagesFrom(latestStatus: latest.id!.uuidString, client: client)
		}
	}

	private func fetchNewPages(minId: String, maxPages: Int) async -> [Product] {
		guard let client else { return [] }
		var pagesLoaded = 0
		var allProducts: [Product] = []
		var latestMinId = minId
		do {
			while
				!Task.isCancelled,
				var newProducts: [Product] =
					try await client.get(endpoint: timeline.endpoint(sinceId: nil,
																	 maxId: nil,
																	 minId: latestMinId,
																	 offset: datasource.get().count)),
				!newProducts.isEmpty,
				pagesLoaded < maxPages
			{
				pagesLoaded += 1

				ProductDataControllerProvider.shared.updateDataControllers(for: newProducts, client: client)

				allProducts.insert(contentsOf: newProducts, at: 0)
//				latestMinId = newProducts.first?.id.uuidString ?? ""
			}
		} catch {
			return allProducts
		}
		return allProducts
	}

	func fetchNextPage() async {
		guard let client else { return }
		do {
			let statuses = await datasource.get()
//			guard let lastId = statuses.last?.id else { return }
			productsState = await .display(products: datasource.getFiltered(), nextPageState: .loadingNextPage)

			var response: ResponseData<[Product]> = try await client.get(endpoint: Products.fetchAll(limit: limit ?? 20, page: page))

			await datasource.append(contentOf: response.data)

			ProductDataControllerProvider.shared.updateDataControllers(for: response.data, client: client)

			productsState = await .display(products: Product.placeholders(), nextPageState: response.data.count < 20 ? .none : .hasNextPage)

		} catch {
			productsState = .error(error: error)
			print("ERROR fetchNextPage() \(error.localizedDescription)")
		}
	}

	func productDidAppear(product status: Product) {
		pendingStatusesObserver.removeStatus(status: status)
		visibileStatuses.insert(status, at: 0)

		if let client, timeline.supportNewestPagination {
			Task {
				await cache.setLatestSeenStatuses(visibileStatuses, for: client, filter: timeline.id)
			}
		}
	}

	func productDidDisappear(product: Product) {
		visibileStatuses.removeAll(where: { $0.id == product.id })
	}
}

// MARK: - MARKER
extension ProductTimelineListViewModel {
	func fetchMarker() async -> Marker.Content? {
//		guard let client else {
//			return nil
//		}
//		do {
//			let data: Marker = try await client.get(endpoint: Markers.markers)
//			return data.home
//		} catch {
			return nil
//		}
	}

	func saveMarker() {
//		guard timeline == .home, let client else { return }
//		Task {
//			guard let id = await cache.getLatestSeenStatus(for: client, filter: timeline.id)?.first else { return }
//			do {
//				let _: Marker = try await client.post(endpoint: Markers.markHome(lastReadId: id))
//			} catch { }
//		}
	}
}


