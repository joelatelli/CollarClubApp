//
//  EventsListView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import Shimmer
import SwiftUI

@MainActor
struct EventsListView: View {
	@Environment(\.scenePhase) private var scenePhase
	@Environment(Theme.self) private var theme
	@Environment(StreamWatcher.self) private var watcher
	@Environment(Client.self) private var client
	@Environment(RouterPath.self) private var routerPath
	@Environment(CurrentAccount.self) private var account
	@State private var viewModel = EventsViewModel()
	@Binding var scrollToTopSignal: Int

	public init(scrollToTopSignal: Binding<Int>) {
		_scrollToTopSignal = scrollToTopSignal
	}

	public var body: some View {
		ScrollViewReader { proxy in
			List {
				eventsView
			}
			.id(account.account?.id)
			.environment(\.defaultMinListRowHeight, 1)
			.listStyle(.plain)
			.onChange(of: scrollToTopSignal) {
				withAnimation {
					proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
				}
			}
		}
		.toolbar {
			toolbarTitleView
			toolbarAuth
		}
		.navigationBarTitleDisplayMode(.inline)
#if !os(visionOS)
		.scrollContentBackground(.hidden)
		.background(theme.primaryBackgroundColor)
#endif
		.onAppear {
			viewModel.client = client
			viewModel.currentAccount = account
			viewModel.loadSelectedType()

			Task {
				await viewModel.fetchEvents()
			}
		}
		.refreshable {
			HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
			await viewModel.fetchEvents()
			HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
		}
		.onChange(of: watcher.latestEvent?.id) {
			if let latestEvent = watcher.latestEvent {
				viewModel.handleEvent(event: latestEvent)
			}
		}
		.onChange(of: scenePhase) { _, newValue in
			switch newValue {
			case .active:
				Task {
					await viewModel.fetchEvents()
				}
			default:
				break
			}
		}
	}

	@ViewBuilder
	private var eventsView: some View {
		switch viewModel.state {
		case .loading:
			ForEach(Event.placeholders()) { event in
				EventRowView(event: event,
							 client: client,
							 routerPath: routerPath)
				.listRowInsets(.init(top: 0,
									 leading: 0,
									 bottom: 0,
									 trailing: 0))
				#if os(visionOS)
				.listRowBackground(RoundedRectangle(cornerRadius: 8)
					.foregroundStyle(Material.regular))
				#else
				.listRowBackground(theme.primaryBackgroundColor)
				#endif
				.redacted(reason: .placeholder)
				.allowsHitTesting(false)
			}

		case let .display(events, nextPageState):
			if events.isEmpty {
				EmptyListView(iconName: "calendar",
							  title: "Events",
							  message: "There are no scheduled events")
#if !os(visionOS)
				.listRowBackground(theme.primaryBackgroundColor)
#endif
				.listSectionSeparator(.hidden)
			} else {
				ForEach(events) { event in
					EventRowView(event: event,
								 client: client,
								 routerPath: routerPath)
					.listRowInsets(.init(top: 0,
										 leading: 0,
										 bottom: 0,
										 trailing: 0))
#if os(visionOS)
					.listRowBackground(RoundedRectangle(cornerRadius: 8)
						.foregroundStyle(Material.regular))
#else
					.listRowBackground(theme.primaryBackgroundColor)
#endif
					.id(event.id)
				}
			}

			switch nextPageState {
			case .none:
				EmptyView()
			case .hasNextPage:
				loadingRow
					.onAppear {
						Task {
							await viewModel.fetchNextPage()
						}
					}
			case .loadingNextPage:
				loadingRow
			}

		case .error:
			ErrorView(title: "notifications.error.title",
					  message: "notifications.error.message",
					  buttonTitle: "action.retry")
			{
				Task {
					await viewModel.fetchEvents()
				}
			}
#if !os(visionOS)
			.listRowBackground(theme.primaryBackgroundColor)
#endif
			.listSectionSeparator(.hidden)
		}
	}

	private var loadingRow: some View {
		HStack {
			Spacer()
			ProgressView()
			Spacer()
		}
		.listRowInsets(.init(top: .layoutPadding,
							 leading: .layoutPadding + 4,
							 bottom: .layoutPadding,
							 trailing: .layoutPadding))
#if !os(visionOS)
		.listRowBackground(theme.primaryBackgroundColor)
#endif
	}

	private var topPaddingView: some View {
		HStack {}
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
			.listRowInsets(.init())
			.frame(height: .layoutPadding)
			.accessibilityHidden(true)
	}

	private var scrollToTopView: some View {
		ScrollToView()
			.frame(height: .scrollToViewHeight)
			.onAppear {
				viewModel.scrollToTopVisible = true
			}
			.onDisappear {
				viewModel.scrollToTopVisible = false
			}
	}

	@ToolbarContentBuilder
	private var toolbarTitleView: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			Text("Events")
				.font(.headline)
				.accessibilityRepresentation {
					Menu("Events") {}
				}
				.accessibilityAddTraits(.isHeader)
				.accessibilityRemoveTraits(.isButton)
				.accessibilityRespondsToUserInteraction(true)
		}
	}

	@ToolbarContentBuilder
	private var toolbarAuth: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Button {
				Auth().token = nil
			} label: {
				Text("Logout")
			}
		}
	}
}

