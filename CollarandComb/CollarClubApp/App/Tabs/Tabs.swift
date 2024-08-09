//
//  Tabs.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation
import SwiftUI

@MainActor
enum Tab: Int, Identifiable, Hashable, CaseIterable, Codable {
  case timeline, notifications, mentions, explore, messages, settings, other
  case trending, federated, local
  case profile
  case bookmarks
  case favorites
  case post
  case followedTags
  case lists

  nonisolated var id: Int {
	rawValue
  }

  static func loggedOutTab() -> [Tab] {
	[.timeline, .settings]
  }

  static func visionOSTab() -> [Tab] {
	[.profile, .timeline, .notifications, .mentions, .explore, .messages, .settings]
  }

  @ViewBuilder
  func makeContentView(selectedTab: Binding<Tab>, popToRootTab: Binding<Tab>) -> some View {
	switch self {
	case .timeline:
	  TimelineTab(popToRootTab: popToRootTab)
	case .trending:
	  TimelineTab(popToRootTab: popToRootTab, timeline: .trending)
	case .local:
	  TimelineTab(popToRootTab: popToRootTab, timeline: .local)
	case .federated:
	  TimelineTab(popToRootTab: popToRootTab, timeline: .federated)
	case .notifications:
		CombTab(popToRootTab: popToRootTab)
	case .mentions:
		EmptyView()
//	  NotificationsTab(selectedTab: selectedTab, popToRootTab: popToRootTab, lockedType: .mention)
	case .explore:
		EventsTab(popToRootTab: popToRootTab)
//	  ExploreTab(popToRootTab: popToRootTab)
	case .messages:
		EmptyView()
//	  MessagesTab(popToRootTab: popToRootTab)
	case .settings:
		EmptyView()
//	  SettingsTabs(popToRootTab: popToRootTab, isModal: false)
	case .profile:
	  ProfileTab(popToRootTab: popToRootTab)
	case .bookmarks:
	  NavigationTab {
		  EmptyView()
//		AccountStatusesListView(mode: .bookmarks)
	  }
	case .favorites:
	  NavigationTab {
		  EmptyView()
//		AccountStatusesListView(mode: .favorites)
	  }
	case .followedTags:
	  NavigationTab {
		  EmptyView()
//		FollowedTagsListView()
	  }
	case .lists:
	  NavigationTab {
		  EmptyView()
//		ListsListView()
	  }
	case .post:
	  VStack { }
	case .other:
	  EmptyView()
	}
  }

  @ViewBuilder
  var label: some View {
	switch self {
	case .timeline:
	  Label("Foam", systemImage: iconName)
	case .trending:
	  Label("tab.trending", systemImage: iconName)
	case .local:
	  Label("tab.local", systemImage: iconName)
	case .federated:
	  Label("tab.federated", systemImage: iconName)
	case .notifications:
	  Label("Comb", systemImage: iconName)
	case .mentions:
	  Label("tab.mentions", systemImage: iconName)
	case .explore:
	  Label("Events", systemImage: iconName)
	case .messages:
	  Label("tab.messages", systemImage: iconName)
	case .settings:
	  Label("tab.settings", systemImage: iconName)
	case .profile:
	  Label("Profile", systemImage: iconName)
	case .bookmarks:
	  Label("accessibility.tabs.profile.picker.bookmarks", systemImage: iconName)
	case .favorites:
	  Label("accessibility.tabs.profile.picker.favorites", systemImage: iconName)
	case .post:
	  Label("menu.new-post", systemImage: iconName)
	case .followedTags:
	  Label("timeline.filter.tags", systemImage: iconName)
	case .lists:
	  Label("timeline.filter.lists", systemImage: iconName)
	case .other:
	  EmptyView()

	}
  }

  var iconName: String {
	switch self {
	case .timeline:
	  "rectangle.stack"
	case .trending:
	  "chart.line.uptrend.xyaxis"
	case .local:
	  "person.2"
	case .federated:
	  "globe.americas"
	case .notifications:
	  "bell"
	case .mentions:
	  "at"
	case .explore:
	  "magnifyingglass"
	case .messages:
	  "tray"
	case .settings:
	  "gear"
	case .profile:
	  "person.crop.circle"
	case .bookmarks:
	  "bookmark"
	case .favorites:
	  "star"
	case .post:
	  "square.and.pencil"
	case .followedTags:
	  "tag"
	case .lists:
	  "list.bullet"
	case .other:
	  ""
	}
  }
}

@Observable
class SidebarTabs {
  struct SidedebarTab: Hashable, Codable {
	let tab: Tab
	var enabled: Bool
  }

  class Storage {
	@AppStorage("sidebar_tabs") var tabs: [SidedebarTab] = [
	  .init(tab: .timeline, enabled: true),
	  .init(tab: .trending, enabled: true),
	  .init(tab: .federated, enabled: true),
	  .init(tab: .local, enabled: true),
	  .init(tab: .notifications, enabled: true),
	  .init(tab: .mentions, enabled: true),
	  .init(tab: .messages, enabled: true),
	  .init(tab: .explore, enabled: true),
	  .init(tab: .bookmarks, enabled: true),
	  .init(tab: .favorites, enabled: true),
	  .init(tab: .followedTags, enabled: true),
	  .init(tab: .lists, enabled: true),

	  .init(tab: .settings, enabled: true),
	  .init(tab: .profile, enabled: true),
	]
  }

  private let storage = Storage()
  public static let shared = SidebarTabs()

  var tabs: [SidedebarTab] {
	didSet {
	  storage.tabs = tabs
	}
  }

  func isEnabled(_ tab: Tab) -> Bool {
	tabs.first(where: { $0.tab.id == tab.id })?.enabled == true
  }

  private init() {
	tabs = storage.tabs
  }
}

@Observable
class iOSTabs {
  enum TabEntries: String {
	case first, second, third, fourth, fifth
  }

  class Storage {
	@AppStorage(TabEntries.first.rawValue) var firstTab = Tab.timeline
	@AppStorage(TabEntries.second.rawValue) var secondTab = Tab.notifications
	@AppStorage(TabEntries.third.rawValue) var thirdTab = Tab.explore
	@AppStorage(TabEntries.fourth.rawValue) var fourthTab = Tab.messages
	@AppStorage(TabEntries.fifth.rawValue) var fifthTab = Tab.profile
  }

  private let storage = Storage()
  public static let shared = iOSTabs()

  var tabs: [Tab] {
	[firstTab, secondTab, thirdTab, fifthTab]
  }

  var firstTab: Tab {
	didSet {
	  storage.firstTab = firstTab
	}
  }

  var secondTab: Tab {
	didSet {
	  storage.secondTab = secondTab
	}
  }

  var thirdTab: Tab {
	didSet {
	  storage.thirdTab = thirdTab
	}
  }

  var fourthTab: Tab {
	didSet {
	  storage.fourthTab = fourthTab
	}
  }

  var fifthTab: Tab {
	didSet {
	  storage.fifthTab = fifthTab
	}
  }

  private init() {
	firstTab = storage.firstTab
	secondTab = storage.secondTab
	thirdTab = storage.thirdTab
	fourthTab = storage.fourthTab
	fifthTab = storage.fifthTab
  }
}

