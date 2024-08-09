//
//  UserPreferences.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Combine
import Foundation
import Network
import SwiftUI

@MainActor
@Observable class UserPreferences {
	class Storage {
		@AppStorage("preferred_browser") var preferredBrowser: PreferredBrowser = .inAppSafari
		@AppStorage("show_translate_button_inline") var showTranslateButton: Bool = true
		@AppStorage("show_pending_at_bottom") var pendingShownAtBottom: Bool = false
		@AppStorage("show_pending_left") var pendingShownLeft: Bool = false
		@AppStorage("is_open_ai_enabled") var isOpenAIEnabled: Bool = true

		@AppStorage("recently_used_languages") var recentlyUsedLanguages: [String] = []
		@AppStorage("social_keyboard_composer") var isSocialKeyboardEnabled: Bool = false

		@AppStorage("use_instance_content_settings") var useInstanceContentSettings: Bool = true
		@AppStorage("app_auto_expand_spoilers") var appAutoExpandSpoilers = false
		@AppStorage("app_auto_expand_media") var appAutoExpandMedia: ServerPreferences.AutoExpandMedia = .hideSensitive
		@AppStorage("app_default_post_visibility") var appDefaultPostVisibility: Visibility = .pub
		@AppStorage("app_default_reply_visibility") var appDefaultReplyVisibility: Visibility = .pub
		@AppStorage("app_default_posts_sensitive") var appDefaultPostsSensitive = false
		@AppStorage("autoplay_video") var autoPlayVideo = true
		@AppStorage("mute_video") var muteVideo = true
		@AppStorage("always_use_deepl") var alwaysUseDeepl = false
		@AppStorage("user_deepl_api_free") var userDeeplAPIFree = true
		@AppStorage("auto_detect_post_language") var autoDetectPostLanguage = true

		@AppStorage("inAppBrowserReaderView") var inAppBrowserReaderView = false

		@AppStorage("haptic_tab") var hapticTabSelectionEnabled = true
		@AppStorage("haptic_timeline") var hapticTimelineEnabled = true
		@AppStorage("haptic_button_press") var hapticButtonPressEnabled = true
		@AppStorage("sound_effect_enabled") var soundEffectEnabled = true

		@AppStorage("show_tab_label_iphone") var showiPhoneTabLabel = true
		@AppStorage("show_alt_text_for_media") var showAltTextForMedia = true

		@AppStorage("show_second_column_ipad") var showiPadSecondaryColumn = true

		@AppStorage("swipeactions-status-leading-left") var swipeActionsStatusLeadingLeft = ProductAction.bookmark
		@AppStorage("swipeactions-status-leading-right") var swipeActionsStatusLeadingRight = ProductAction.none
		@AppStorage("swipeactions-use-theme-color") var swipeActionsUseThemeColor = false
		@AppStorage("swipeactions-icon-style") var swipeActionsIconStyle: SwipeActionsIconStyle = .iconWithText

		@AppStorage("requested_review") public var requestedReview = false

		@AppStorage("collapse-long-posts") var collapseLongPosts = true

		@AppStorage("share-button-behavior") var shareButtonBehavior: PreferredShareButtonBehavior = .linkAndText

		@AppStorage("fast_refresh") var fastRefreshEnabled: Bool = false

		@AppStorage("max_reply_indentation") var maxReplyIndentation: UInt = 7
		@AppStorage("show_reply_indentation") var showReplyIndentation: Bool = true

		@AppStorage("show_account_popover") var showAccountPopover: Bool = true

		init() {}
	}

	static let sharedDefault = UserDefaults(suiteName: "group.com.thomasricouard.IceCubesApp")
	static let shared = UserPreferences()
	private let storage = Storage()

	private var client: Client?

	var preferredBrowser: PreferredBrowser {
		didSet {
			storage.preferredBrowser = preferredBrowser
		}
	}

	var showTranslateButton: Bool {
		didSet {
			storage.showTranslateButton = showTranslateButton
		}
	}

	var pendingShownAtBottom: Bool {
		didSet {
			storage.pendingShownAtBottom = pendingShownAtBottom
		}
	}

	var pendingShownLeft: Bool {
		didSet {
			storage.pendingShownLeft = pendingShownLeft
		}
	}

	var pendingLocation: Alignment {
		let fromLeft = Locale.current.language.characterDirection == .leftToRight ? pendingShownLeft : !pendingShownLeft
		if pendingShownAtBottom {
			if fromLeft {
				return .bottomLeading
			} else {
				return .bottomTrailing
			}
		} else {
			if fromLeft {
				return .topLeading
			} else {
				return .topTrailing
			}
		}
	}

	var isOpenAIEnabled: Bool {
		didSet {
			storage.isOpenAIEnabled = isOpenAIEnabled
		}
	}

	var recentlyUsedLanguages: [String] {
		didSet {
			storage.recentlyUsedLanguages = recentlyUsedLanguages
		}
	}

	var isSocialKeyboardEnabled: Bool {
		didSet {
			storage.isSocialKeyboardEnabled = isSocialKeyboardEnabled
		}
	}

	var useInstanceContentSettings: Bool {
		didSet {
			storage.useInstanceContentSettings = useInstanceContentSettings
		}
	}

	var appAutoExpandSpoilers: Bool {
		didSet {
			storage.appAutoExpandSpoilers = appAutoExpandSpoilers
		}
	}

	var appAutoExpandMedia: ServerPreferences.AutoExpandMedia {
		didSet {
			storage.appAutoExpandMedia = appAutoExpandMedia
		}
	}

	var appDefaultPostVisibility: Visibility {
		didSet {
			storage.appDefaultPostVisibility = appDefaultPostVisibility
		}
	}

	var appDefaultReplyVisibility: Visibility {
		didSet {
			storage.appDefaultReplyVisibility = appDefaultReplyVisibility
		}
	}

	var appDefaultPostsSensitive: Bool {
		didSet {
			storage.appDefaultPostsSensitive = appDefaultPostsSensitive
		}
	}

	var autoPlayVideo: Bool {
		didSet {
			storage.autoPlayVideo = autoPlayVideo
		}
	}

	var muteVideo: Bool {
		didSet {
			storage.muteVideo = muteVideo
		}
	}


	var alwaysUseDeepl: Bool {
		didSet {
			storage.alwaysUseDeepl = alwaysUseDeepl
		}
	}

	var userDeeplAPIFree: Bool {
		didSet {
			storage.userDeeplAPIFree = userDeeplAPIFree
		}
	}

	var autoDetectPostLanguage: Bool {
		didSet {
			storage.autoDetectPostLanguage = autoDetectPostLanguage
		}
	}

	var inAppBrowserReaderView: Bool {
		didSet {
			storage.inAppBrowserReaderView = inAppBrowserReaderView
		}
	}

	var hapticTabSelectionEnabled: Bool {
		didSet {
			storage.hapticTabSelectionEnabled = hapticTabSelectionEnabled
		}
	}

	var hapticTimelineEnabled: Bool {
		didSet {
			storage.hapticTimelineEnabled = hapticTimelineEnabled
		}
	}

	var hapticButtonPressEnabled: Bool {
		didSet {
			storage.hapticButtonPressEnabled = hapticButtonPressEnabled
		}
	}

	var soundEffectEnabled: Bool {
		didSet {
			storage.soundEffectEnabled = soundEffectEnabled
		}
	}

	var showiPhoneTabLabel: Bool {
		didSet {
			storage.showiPhoneTabLabel = showiPhoneTabLabel
		}
	}

	var showAltTextForMedia: Bool {
		didSet {
			storage.showAltTextForMedia = showAltTextForMedia
		}
	}

	var showiPadSecondaryColumn: Bool {
		didSet {
			storage.showiPadSecondaryColumn = showiPadSecondaryColumn
		}
	}

//	var swipeActionsStatusTrailingRight: ProductAction {
//		didSet {
//			storage.swipeActionsStatusTrailingRight = swipeActionsStatusTrailingRight
//		}
//	}

//	var swipeActionsStatusTrailingLeft: ProductAction {
//		didSet {
//			storage.swipeActionsStatusTrailingLeft = swipeActionsStatusTrailingLeft
//		}
//	}

	var swipeActionsStatusLeadingLeft: ProductAction {
		didSet {
			storage.swipeActionsStatusLeadingLeft = swipeActionsStatusLeadingLeft
		}
	}

	var swipeActionsStatusLeadingRight: ProductAction {
		didSet {
			storage.swipeActionsStatusLeadingRight = swipeActionsStatusLeadingRight
		}
	}

	var swipeActionsUseThemeColor: Bool {
		didSet {
			storage.swipeActionsUseThemeColor = swipeActionsUseThemeColor
		}
	}

	var swipeActionsIconStyle: SwipeActionsIconStyle {
		didSet {
			storage.swipeActionsIconStyle = swipeActionsIconStyle
		}
	}

	var requestedReview: Bool {
		didSet {
			storage.requestedReview = requestedReview
		}
	}

	var collapseLongPosts: Bool {
		didSet {
			storage.collapseLongPosts = collapseLongPosts
		}
	}

	var shareButtonBehavior: PreferredShareButtonBehavior {
		didSet {
			storage.shareButtonBehavior = shareButtonBehavior
		}
	}

	var fastRefreshEnabled: Bool {
		didSet {
			storage.fastRefreshEnabled = fastRefreshEnabled
		}
	}

	var maxReplyIndentation: UInt {
		didSet {
			storage.maxReplyIndentation = maxReplyIndentation
		}
	}

	var showReplyIndentation: Bool {
		didSet {
			storage.showReplyIndentation = showReplyIndentation
		}
	}

	var showAccountPopover: Bool {
		didSet {
			storage.showAccountPopover = showAccountPopover
		}
	}

	func getRealMaxIndent() -> UInt {
		showReplyIndentation ? maxReplyIndentation : 0
	}

	enum SwipeActionsIconStyle: String, CaseIterable {
		case iconWithText, iconOnly

		var description: LocalizedStringKey {
			switch self {
			case .iconWithText:
				"enum.swipeactions.icon-with-text"
			case .iconOnly:
				"enum.swipeactions.icon-only"
			}
		}

		// Have to implement this manually here due to compiler not implicitly
		// inserting `nonisolated`, which leads to a warning:
		//
		//     Main actor-isolated static property 'allCases' cannot be used to
		//     satisfy nonisolated protocol requirement
		//
		nonisolated static var allCases: [Self] {
			[.iconWithText, .iconOnly]
		}
	}

	var postVisibility: Visibility {
		if useInstanceContentSettings {
			serverPreferences?.postVisibility ?? .pub
		} else {
			appDefaultPostVisibility
		}
	}

	func conformReplyVisibilityConstraints() {
		appDefaultReplyVisibility = getReplyVisibility()
	}

	func getReplyVisibility() -> Visibility {
		getMinVisibility(postVisibility, appDefaultReplyVisibility)
	}

	func getReplyVisibility(of status: Product) -> Visibility {
//		getMinVisibility(getReplyVisibility(), status.visibility ?? .pub)
		return .pub
	}

	private func getMinVisibility(_ vis1: Visibility, _ vis2: Visibility) -> Visibility {
		let no1 = Self.getIntOfVisibility(vis1)
		let no2 = Self.getIntOfVisibility(vis2)

		return no1 < no2 ? vis1 : vis2
	}

	var postIsSensitive: Bool {
		if useInstanceContentSettings {
			serverPreferences?.postIsSensitive ?? false
		} else {
			appDefaultPostsSensitive
		}
	}

	var autoExpandSpoilers: Bool {
		if useInstanceContentSettings {
			serverPreferences?.autoExpandSpoilers ?? true
		} else {
			appAutoExpandSpoilers
		}
	}

	var autoExpandMedia: ServerPreferences.AutoExpandMedia {
		if useInstanceContentSettings {
			serverPreferences?.autoExpandMedia ?? .hideSensitive
		} else {
			appAutoExpandMedia
		}
	}

	var notificationsCount: [OauthToken: Int] = [:] {
		didSet {
			for (key, value) in notificationsCount {
				Self.sharedDefault?.set(value, forKey: "push_notifications_count_\(key.createdAt)")
			}
		}
	}

	var totalNotificationsCount: Int {
		notificationsCount.compactMap{ $0.value }.reduce(0, +)
	}

	func reloadNotificationsCount(tokens: [OauthToken]) {
		notificationsCount = [:]
		for token in tokens {
			notificationsCount[token] = Self.sharedDefault?.integer(forKey: "push_notifications_count_\(token.createdAt)") ?? 0
		}
	}

	var serverPreferences: ServerPreferences?

	func setClient(client: Client) {
		self.client = client
		Task {
			await refreshServerPreferences()
		}
	}

	func refreshServerPreferences() async {
		guard let client, client.isAuth else { return }
		serverPreferences = try? await client.get(endpoint: Accounts.preferences)
	}

	func markLanguageAsSelected(isoCode: String) {
		var copy = recentlyUsedLanguages
		if let index = copy.firstIndex(of: isoCode) {
			copy.remove(at: index)
		}
		copy.insert(isoCode, at: 0)
		recentlyUsedLanguages = Array(copy.prefix(3))
	}

	static func getIntOfVisibility(_ vis: Visibility) -> Int {
		switch vis {
		case .direct:
			0
		case .priv:
			1
		case .unlisted:
			2
		case .pub:
			3
		}
	}

	private init() {
		preferredBrowser = storage.preferredBrowser
		showTranslateButton = storage.showTranslateButton
		isOpenAIEnabled = storage.isOpenAIEnabled
		recentlyUsedLanguages = storage.recentlyUsedLanguages
		isSocialKeyboardEnabled = storage.isSocialKeyboardEnabled
		useInstanceContentSettings = storage.useInstanceContentSettings
		appAutoExpandSpoilers = storage.appAutoExpandSpoilers
		appAutoExpandMedia = storage.appAutoExpandMedia
		appDefaultPostVisibility = storage.appDefaultPostVisibility
		appDefaultReplyVisibility = storage.appDefaultReplyVisibility
		appDefaultPostsSensitive = storage.appDefaultPostsSensitive
		autoPlayVideo = storage.autoPlayVideo
		alwaysUseDeepl = storage.alwaysUseDeepl
		userDeeplAPIFree = storage.userDeeplAPIFree
		autoDetectPostLanguage = storage.autoDetectPostLanguage
		inAppBrowserReaderView = storage.inAppBrowserReaderView
		hapticTabSelectionEnabled = storage.hapticTabSelectionEnabled
		hapticTimelineEnabled = storage.hapticTimelineEnabled
		hapticButtonPressEnabled = storage.hapticButtonPressEnabled
		soundEffectEnabled = storage.soundEffectEnabled
		showiPhoneTabLabel = storage.showiPhoneTabLabel
		showAltTextForMedia = storage.showAltTextForMedia
		showiPadSecondaryColumn = storage.showiPadSecondaryColumn
//		swipeActionsStatusTrailingRight = storage.swipeActionsStatusTrailingRight
//		swipeActionsStatusTrailingLeft = storage.swipeActionsStatusTrailingLeft
		swipeActionsStatusLeadingLeft = storage.swipeActionsStatusLeadingLeft
		swipeActionsStatusLeadingRight = storage.swipeActionsStatusLeadingRight
		swipeActionsUseThemeColor = storage.swipeActionsUseThemeColor
		swipeActionsIconStyle = storage.swipeActionsIconStyle
		requestedReview = storage.requestedReview
		collapseLongPosts = storage.collapseLongPosts
		shareButtonBehavior = storage.shareButtonBehavior
		pendingShownAtBottom = storage.pendingShownAtBottom
		pendingShownLeft = storage.pendingShownLeft
		fastRefreshEnabled = storage.fastRefreshEnabled
		maxReplyIndentation = storage.maxReplyIndentation
		showReplyIndentation = storage.showReplyIndentation
		showAccountPopover = storage.showAccountPopover
		muteVideo = storage.muteVideo
	}
}

extension UInt: RawRepresentable {
	public var rawValue: Int {
		Int(self)
	}

	public init?(rawValue: Int) {
		if rawValue >= 0 {
			self.init(rawValue)
		} else {
			return nil
		}
	}
}

