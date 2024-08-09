//
//  CollarClubApp+Scene.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import SwiftUI

extension CollarClubApp {
	var appScene: some Scene {
		WindowGroup(id: "MainWindow") {
			if isSignedIn {
				AppView(selectedTab: $selectedTab, appRouterPath: $appRouterPath)
					.applyTheme(theme)
					.onAppear {
						currentUser.setMe()
//						userVM.setMe()
						setNewClientsInEnv(client: appAccountsManager.currentClient)
						setupRevenueCat()
						refreshPushSubs()
					}
					.environment(appAccountsManager)
					.environment(appAccountsManager.currentClient)
					.environment(quickLook)
					.environment(currentAccount)
					.environment(currentUser)
					.environment(cartManager)
					.environment(currentInstance)
					.environment(userPreferences)
					.environment(theme)
					.environment(watcher)
					.environment(pushNotificationsService)
					.environment(\.isSupporter, isSupporter)
					.sheet(item: $quickLook.selectedMediaAttachment) { selectedMediaAttachment in
						MediaUIView(selectedAttachment: selectedMediaAttachment,
									attachments: quickLook.mediaAttachments)
						.presentationBackground(.ultraThinMaterial)
						.presentationCornerRadius(16)
						.withEnvironments()
					}
					.onChange(of: pushNotificationsService.handledNotification) { _, newValue in
						if newValue != nil {
							pushNotificationsService.handledNotification = nil
							if appAccountsManager.currentAccount.oauthToken?.accessToken != newValue?.account.token.accessToken,
							   let account = appAccountsManager.availableAccounts.first(where:
																							{ $0.oauthToken?.accessToken == newValue?.account.token.accessToken })
							{
								appAccountsManager.currentAccount = account
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
									selectedTab = .notifications
									pushNotificationsService.handledNotification = newValue
								}
							} else {
								selectedTab = .notifications
							}
						}
					}
					.withModelContainer()
			} else {
				SignInView(isSignedIn: $isSignedIn)
			}
		}
		.commands {
			appMenu
		}
		.onChange(of: scenePhase) { _, newValue in
			handleScenePhase(scenePhase: newValue)
		}
		.onChange(of: appAccountsManager.currentClient) { _, newValue in
			setNewClientsInEnv(client: newValue)
			if newValue.isAuth {
				watcher.watch(streams: [.user, .direct])
			}
		}
	}

	@SceneBuilder
	var otherScenes: some Scene {
		WindowGroup(for: WindowDestinationEditor.self) { destination in
			Group {
//				switch destination.wrappedValue {
//				case let .newStatusEditor(visibility):
//					ProductEditor.MainView(mode: .new(visibility: visibility))
//				case let .editStatusEditor(status):
//					ProductEditor.MainView(mode: .edit(status: status))
//				case .none:
//					EmptyView()
//				}
			}
			.withEnvironments()
			.withModelContainer()
			.applyTheme(theme)
			.frame(minWidth: 300, minHeight: 400)
		}
		.defaultSize(width: 600, height: 800)
		.windowResizability(.contentMinSize)

		WindowGroup(for: WindowDestinationMedia.self) { destination in
			Group {
				switch destination.wrappedValue {
				case let .mediaViewer(attachments, selectedAttachment):
					MediaUIView(selectedAttachment: selectedAttachment,
								attachments: attachments)
				case .none:
					EmptyView()
				}
			}
			.withEnvironments()
			.withModelContainer()
			.applyTheme(theme)
			.frame(minWidth: 300, minHeight: 400)
		}
		.defaultSize(width: 1200, height: 1000)
		.windowResizability(.contentMinSize)
	}
}

