//
//  EditPetProfileView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import SwiftUI
import NukeUI

@MainActor
struct EditPetProfileView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(Client.self) private var client
	@Environment(Theme.self) private var theme
	@Environment(CurrentUser.self) private var currentUser
	@Environment(UserPreferences.self) private var userPrefs

	@State private var viewModel: EditPetProfileViewModel

	init(mode: EditPetProfileViewModel.Mode) {
		_viewModel = .init(initialValue: .init(mode: mode))
	}

	var body: some View {
		NavigationStack {
			Form {
				if viewModel.isLoading {
					loadingSection
				} else {
					aboutSection
				}
			}
			.environment(\.editMode, .constant(.active))
#if !os(visionOS)
			.scrollContentBackground(.hidden)
			.background(theme.secondaryBackgroundColor)
			.scrollDismissesKeyboard(.immediately)
#endif
			.navigationTitle(viewModel.mode.title)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				toolbarContent
			}
			.alert("account.edit.error.save.title",
				   isPresented: $viewModel.saveError,
				   actions: {
				Button("alert.button.ok", action: {})
			}, message: { Text("account.edit.error.save.message") })
			.task {
				viewModel.client = client
				viewModel.accountId = currentUser.user?.id?.uuidString
				await viewModel.setInfo()
			}
		}
	}

	private var loadingSection: some View {
		Section {
			HStack {
				Spacer()
				ProgressView()
				Spacer()
			}
		}
#if !os(visionOS)
		.listRowBackground(theme.primaryBackgroundColor)
#endif
	}

	private var imagesSection: some View {
		Section {
			ZStack(alignment: .center) {
				if let header = viewModel.header {
					ZStack(alignment: .topLeading) {
						LazyImage(url: header) { state in
							if let image = state.image {
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(height: 150)
									.clipShape(RoundedRectangle(cornerRadius: 8))
									.clipped()
							} else {
								RoundedRectangle(cornerRadius: 8)
									.foregroundStyle(theme.primaryBackgroundColor)
									.frame(height: 150)
							}
						}
						.frame(height: 150)
					}
				}
				if let avatar = viewModel.avatar {
					ZStack(alignment: .bottomLeading) {
						AvatarView(avatar, config: .account)
						Menu {
							Button("account.edit.avatar") {
								viewModel.isChangingAvatar = true
								viewModel.isPhotoPickerPresented = true
							}
							Button("account.edit.header") {
								viewModel.isChangingHeader = true
								viewModel.isPhotoPickerPresented = true
							}
						} label: {
							Image(systemName: "photo.badge.plus")
								.foregroundStyle(.white)
						}
						.buttonStyle(.borderedProminent)
						.clipShape(Circle())
						.offset(x: -8, y: 8)
					}
				}
			}
			.overlay {
				if viewModel.isChangingAvatar || viewModel.isChangingHeader {
					ZStack(alignment: .center) {
						RoundedRectangle(cornerRadius: 8)
							.foregroundStyle(Color.black.opacity(0.40))
						ProgressView()
					}
				}
			}
			.listRowInsets(EdgeInsets())
		}
		.listRowBackground(theme.secondaryBackgroundColor)
		.photosPicker(isPresented: $viewModel.isPhotoPickerPresented,
					  selection: $viewModel.mediaPickers,
					  maxSelectionCount: 1,
					  matching: .any(of: [.images]),
					  photoLibrary: .shared())
	}

	@ViewBuilder
	private var aboutSection: some View {
		Section("Name") {
			TextField("What's the name of your pet?", text: $viewModel.name)
		}
		.listRowBackground(theme.primaryBackgroundColor)

		Section("Age") {
			TextField("What's your  pets age?", text: $viewModel.age)
				.frame(maxHeight: 150)
		}
		.listRowBackground(theme.primaryBackgroundColor)

		Section("Breed") {
			TextField("What's the  breeed of your pet?", text: $viewModel.breed)
		}
		.listRowBackground(theme.primaryBackgroundColor)

		Section("Weight") {
			TextField("How much does your pet weight?", text: $viewModel.weight)
				.frame(maxHeight: 150)
		}
		.listRowBackground(theme.primaryBackgroundColor)

		Section("Temperment") {
			TextField("What's the temperment of your pet?", text: $viewModel.temperment, axis: .vertical)
		}
		.listRowBackground(theme.primaryBackgroundColor)

		Section("Special Needs") {
			TextField("Does your pet have any special needs?", text: $viewModel.specialNeeds, axis: .vertical)
				.frame(maxHeight: 150)
		}
		.listRowBackground(theme.primaryBackgroundColor)

		Section("Last Vaccinated") {
			TextField("When was your pet last vaccinated (i.e. August 1, 2023)?", text: $viewModel.lastVaccinated)
				.frame(maxHeight: 150)
		}
		.listRowBackground(theme.primaryBackgroundColor)
	}

	private var postSettingsSection: some View {
		Section("account.edit.post-settings.section-title") {
			if !userPrefs.useInstanceContentSettings {
				Text("account.edit.post-settings.content-settings-reference")
			}
			Picker(selection: $viewModel.postPrivacy) {
				ForEach(Visibility.supportDefault, id: \.rawValue) { privacy in
					Text(privacy.title).tag(privacy)
				}
			} label: {
				Label("account.edit.post-settings.privacy", systemImage: "lock")
			}
			.pickerStyle(.menu)
			Toggle(isOn: $viewModel.isSensitive) {
				Label("account.edit.post-settings.sensitive", systemImage: "eye")
			}
		}
#if !os(visionOS)
		.listRowBackground(theme.primaryBackgroundColor)
#endif
	}

	private var accountSection: some View {
		Section("account.edit.account-settings.section-title") {
			Toggle(isOn: $viewModel.isLocked) {
				Label("account.edit.account-settings.private", systemImage: "lock")
			}
			Toggle(isOn: $viewModel.isBot) {
				Label("account.edit.account-settings.bot", systemImage: "laptopcomputer.trianglebadge.exclamationmark")
			}
			Toggle(isOn: $viewModel.isDiscoverable) {
				Label("account.edit.account-settings.discoverable", systemImage: "magnifyingglass")
			}
		}
#if !os(visionOS)
		.listRowBackground(theme.primaryBackgroundColor)
#endif
	}

	private var fieldsSection: some View {
		Section("account.edit.metadata-section-title") {
			ForEach($viewModel.fields) { $field in
				VStack(alignment: .leading) {
					TextField("account.edit.metadata-name-placeholder", text: $field.name)
						.font(.scaledHeadline)
					TextField("account.edit.metadata-value-placeholder", text: $field.value)
						.emojiSize(Font.scaledBodyFont.emojiSize)
						.emojiBaselineOffset(Font.scaledBodyFont.emojiBaselineOffset)
						.foregroundColor(theme.tintColor)
				}
			}
			.onMove(perform: { indexSet, newOffset in
				viewModel.fields.move(fromOffsets: indexSet, toOffset: newOffset)
			})
			.onDelete { indexes in
				if let index = indexes.first {
					viewModel.fields.remove(at: index)
				}
			}
			if viewModel.fields.count < 4 {
				Button {
					withAnimation {
						viewModel.fields.append(.init(name: "", value: ""))
					}
				} label: {
					Text("account.edit.add-metadata-button")
						.foregroundColor(theme.tintColor)
				}
			}
		}
#if !os(visionOS)
		.listRowBackground(theme.primaryBackgroundColor)
#endif
	}

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button("Cancel") {
				dismiss()
			}
		}

		ToolbarItem(placement: .navigationBarTrailing) {
			Button {
				Task {
					await viewModel.postProfile()
					dismiss()
				}
			} label: {
				if viewModel.isSaving {
					ProgressView()
				} else {
					Text("Save").bold()
				}
			}
		}
	}
}

