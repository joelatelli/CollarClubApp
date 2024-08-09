//
//  PetProfileDetailContextMenu.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import SwiftUI

struct PetProfileDetailContextMenu: View {
	@Environment(Client.self) private var client
	@Environment(RouterPath.self) private var routerPath
	@Environment(CurrentInstance.self) private var currentInstance
	@Environment(UserPreferences.self) private var preferences

	@Binding var showBlockConfirmation: Bool

	var viewModel: PetProfileDetailViewModel

	public var body: some View {
		if let profile = viewModel.profile {
			Section(profile.name ?? "") {
//				if !viewModel.isCurrentUser {
//					Button {
//						routerPath.presentedSheet = .mentionStatusEditor(account: account,
//																		 visibility: preferences.postVisibility)
//					} label: {
//						Label("account.action.mention", systemImage: "at")
//					}
//					Button {
//						routerPath.presentedSheet = .mentionStatusEditor(account: account, visibility: .direct)
//					} label: {
//						Label("account.action.message", systemImage: "tray.full")
//					}
//
//					Divider()
//
//					if viewModel.relationship?.blocking == true {
//						Button {
//							Task {
//								do {
//									viewModel.relationship = try await client.post(endpoint: Accounts.unblock(id: account.id))
//								} catch {
//									print("Error while unblocking: \(error.localizedDescription)")
//								}
//							}
//						} label: {
//							Label("account.action.unblock", systemImage: "person.crop.circle.badge.exclamationmark")
//						}
//					} else {
//						Button {
//							showBlockConfirmation.toggle()
//						} label: {
//							Label("account.action.block", systemImage: "person.crop.circle.badge.xmark")
//						}
//					}
//
//					if viewModel.relationship?.muting == true {
//						Button {
//							Task {
//								do {
//									viewModel.relationship = try await client.post(endpoint: Accounts.unmute(id: account.id))
//								} catch {
//									print("Error while unmuting: \(error.localizedDescription)")
//								}
//							}
//						} label: {
//							Label("account.action.unmute", systemImage: "speaker")
//						}
//					} else {
//						Menu {
//							ForEach(Duration.mutingDurations(), id: \.rawValue) { duration in
//								Button(duration.description) {
//									Task {
//										do {
//											viewModel.relationship = try await client.post(endpoint: Accounts.mute(id: account.id, json: MuteData(duration: duration.rawValue)))
//										} catch {
//											print("Error while muting: \(error.localizedDescription)")
//										}
//									}
//								}
//							}
//						} label: {
//							Label("account.action.mute", systemImage: "speaker.slash")
//						}
//					}
//
//					if let relationship = viewModel.relationship,
//					   relationship.following
//					{
//						if relationship.notifying {
//							Button {
//								Task {
//									do {
//										viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
//																												 notify: false,
//																												 reblogs: relationship.showingReblogs))
//									} catch {
//										print("Error while disabling notifications: \(error.localizedDescription)")
//									}
//								}
//							} label: {
//								Label("account.action.notify-disable", systemImage: "bell.fill")
//							}
//						} else {
//							Button {
//								Task {
//									do {
//										viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
//																												 notify: true,
//																												 reblogs: relationship.showingReblogs))
//									} catch {
//										print("Error while enabling notifications: \(error.localizedDescription)")
//									}
//								}
//							} label: {
//								Label("account.action.notify-enable", systemImage: "bell")
//							}
//						}
//						if relationship.showingReblogs {
//							Button {
//								Task {
//									do {
//										viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
//																												 notify: relationship.notifying,
//																												 reblogs: false))
//									} catch {
//										print("Error while disabling reboosts: \(error.localizedDescription)")
//									}
//								}
//							} label: {
//								Label("account.action.reboosts-hide", image: "Rocket.Fill")
//							}
//						} else {
//							Button {
//								Task {
//									do {
//										viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
//																												 notify: relationship.notifying,
//																												 reblogs: true))
//									} catch {
//										print("Error while enabling reboosts: \(error.localizedDescription)")
//									}
//								}
//							} label: {
//								Label("account.action.reboosts-show", image: "Rocket")
//							}
//						}
//					}
//
//					Divider()
//				}

				Divider()
			}
		}
	}
}

