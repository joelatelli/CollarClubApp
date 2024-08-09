//
//  EditAccountView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/3/24.
//

import Network
import SwiftUI
import NukeUI

@MainActor
struct EditAccountView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(Client.self) private var client
  @Environment(Theme.self) private var theme
  @Environment(UserPreferences.self) private var userPrefs

  @State private var viewModel = EditAccountViewModel()

  public init() { }

  public var body: some View {
	NavigationStack {
	  Form {
		if viewModel.isLoading {
		  loadingSection
		} else {
		  fieldsSection
		}
	  }
	  .environment(\.editMode, .constant(.active))
	  #if !os(visionOS)
	  .scrollContentBackground(.hidden)
	  .background(theme.secondaryBackgroundColor)
	  .scrollDismissesKeyboard(.immediately)
	  #endif
	  .navigationTitle("account.edit.navigation-title")
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
		await viewModel.fetchAccount()
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
	Section("account.edit.display-name") {
	  TextField("account.edit.display-name", text: $viewModel.displayName)
	}
	.listRowBackground(theme.primaryBackgroundColor)
	Section("account.edit.about") {
	  TextField("account.edit.about", text: $viewModel.note, axis: .vertical)
		.frame(maxHeight: 150)
	}
	#if !os(visionOS)
	.listRowBackground(theme.primaryBackgroundColor)
	#endif
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
	  VStack {
		  Section("First Name") {
			  TextField("Enter your first name", text: $viewModel.firstName)
		  }
		  .listRowBackground(theme.primaryBackgroundColor)

		  Section("Last Name") {
			  TextField("Enter your last name", text: $viewModel.lastName)
				  .frame(maxHeight: 150)
		  }
		  .listRowBackground(theme.primaryBackgroundColor)

		  Section("Email Address") {
			  TextField("Enter your email", text: $viewModel.email)
		  }
		  .listRowBackground(theme.primaryBackgroundColor)

		  Section("Password") {
			  TextField("Enter a Password", text: $viewModel.password)
				  .frame(maxHeight: 150)
		  }
		  .listRowBackground(theme.primaryBackgroundColor)

		  Section("Phone Number") {
			  TextField("Entere you phone number", text: $viewModel.phoneNumber)
		  }
		  .listRowBackground(theme.primaryBackgroundColor)
	  }
  }

  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
	ToolbarItem(placement: .navigationBarLeading) {
	  Button("action.cancel") {
		dismiss()
	  }
	}

	ToolbarItem(placement: .navigationBarTrailing) {
	  Button {
		Task {
		  await viewModel.save()
		  dismiss()
		}
	  } label: {
		if viewModel.isSaving {
		  ProgressView()
		} else {
		  Text("action.save").bold()
		}
	  }
	}
  }
}

