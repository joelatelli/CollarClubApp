//
//  StatusRowSwipeView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

@MainActor
struct StatusRowSwipeView: View {
	@Environment(Theme.self) private var theme
	@Environment(UserPreferences.self) private var preferences
	@Environment(CurrentAccount.self) private var currentAccount
	@Environment(ProductDataController.self) private var statusDataController

	enum Mode {
		case leading, trailing
	}

	func privateBoost() -> Bool {
		return false
//		viewModel.product.visibility == .priv
	}

	var viewModel: ProductRowViewModel
	let mode: Mode

	var body: some View {
		switch mode {
		case .leading:
			leadingSwipeActions
		case .trailing:
			trailingSwipeActions
		}
	}

	@ViewBuilder
	private var trailingSwipeActions: some View {
		EmptyView()
//		if preferences.swipeActionsStatusTrailingRight != ProductAction.none, !viewModel.isRemote {
//			makeSwipeButton(action: preferences.swipeActionsStatusTrailingRight)
//				.tint(preferences.swipeActionsStatusTrailingRight.color(themeTintColor: theme.tintColor, useThemeColor: preferences.swipeActionsUseThemeColor, outside: true))
//		}
//		if preferences.swipeActionsStatusTrailingLeft != ProductAction.none, !viewModel.isRemote {
//			makeSwipeButton(action: preferences.swipeActionsStatusTrailingLeft)
//				.tint(preferences.swipeActionsStatusTrailingLeft.color(themeTintColor: theme.tintColor, useThemeColor: preferences.swipeActionsUseThemeColor, outside: false))
//		}
	}

	@ViewBuilder
	private var leadingSwipeActions: some View {
		if preferences.swipeActionsStatusLeadingLeft != ProductAction.none, !viewModel.isRemote {
			makeSwipeButton(action: preferences.swipeActionsStatusLeadingLeft)
				.tint(preferences.swipeActionsStatusLeadingLeft.color(themeTintColor: theme.tintColor, useThemeColor: preferences.swipeActionsUseThemeColor, outside: true))
		}
		if preferences.swipeActionsStatusLeadingRight != ProductAction.none, !viewModel.isRemote {
			makeSwipeButton(action: preferences.swipeActionsStatusLeadingRight)
				.tint(preferences.swipeActionsStatusLeadingRight.color(themeTintColor: theme.tintColor, useThemeColor: preferences.swipeActionsUseThemeColor, outside: false))
		}
	}

	@ViewBuilder
	private func makeSwipeButton(action: ProductAction) -> some View {
		switch action {
//		case .reply:
//			makeSwipeButtonForRouterPath(action: action, destination: .replyToStatusEditor(status: viewModel.product))
//		case .quote:
//			makeSwipeButtonForRouterPath(action: action, destination: .quoteStatusEditor(status: viewModel.product))
//				.disabled(viewModel.product.visibility == .direct || viewModel.product.visibility == .priv)
//		case .favorite:
//			makeSwipeButtonForTask(action: action) {
//				await statusDataController.toggleBookmark(remoteStatus: nil)
//			}
//		case .boost:
//			makeSwipeButtonForTask(action: action, privateBoost: privateBoost()) {
//				await statusDataController.toggleReblog(remoteStatus: nil)
//			}
//			.disabled(viewModel.status.visibility == .direct || viewModel.status.visibility == .priv && viewModel.status.account.id != currentAccount.account?.id)
		case .bookmark:
			makeSwipeButtonForTask(action: action) {
				await statusDataController.toggleBookmark(remoteStatus: nil)
			}
		case .none:
			EmptyView()
		}
	}

	@ViewBuilder
	private func makeSwipeButtonForRouterPath(action: ProductAction, destination: SheetDestination) -> some View {
		Button {
			HapticManager.shared.fireHaptic(.notification(.success))
			viewModel.routerPath.presentedSheet = destination
		} label: {
			makeSwipeLabel(action: action, style: preferences.swipeActionsIconStyle)
		}
	}

	@ViewBuilder
	private func makeSwipeButtonForTask(action: ProductAction, privateBoost: Bool = false, task: @escaping () async -> Void) -> some View {
		Button {
			Task {
				HapticManager.shared.fireHaptic(.notification(.success))
				await task()
			}
		} label: {
			makeSwipeLabel(action: action, style: preferences.swipeActionsIconStyle, privateBoost: privateBoost)
		}
	}

	@ViewBuilder
	private func makeSwipeLabel(action: ProductAction, style: UserPreferences.SwipeActionsIconStyle, privateBoost: Bool = false) -> some View {
		switch style {
		case .iconOnly:
			Label(action.displayName(isBookmarked: statusDataController.isBookmarked),
				  imageNamed: action.iconName(isBookmarked: statusDataController.isBookmarked))
			.labelStyle(.iconOnly)
			.environment(\.symbolVariants, .none)
		case .iconWithText:
			Label(action.displayName(isBookmarked: statusDataController.isBookmarked),
				  imageNamed: action.iconName(isBookmarked: statusDataController.isBookmarked))
			.labelStyle(.titleAndIcon)
			.environment(\.symbolVariants, .none)
		}
	}
}

