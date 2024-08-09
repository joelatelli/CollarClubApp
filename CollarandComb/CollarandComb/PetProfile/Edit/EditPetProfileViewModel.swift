//
//  EditPetProfileViewModel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/31/24.
//

import Network
import Observation
import SwiftUI
import PhotosUI

@MainActor
@Observable class EditPetProfileViewModel {
	@Observable class FieldEditViewModel: Identifiable {
		let id = UUID().uuidString
		var name: String = ""
		var value: String = ""

		init(name: String, value: String) {
			self.name = name
			self.value = value
		}
	}

	var client: Client?
	var mode: Mode

	var userID: UUID?
	var accountId: String?

	var profile: PetProfile?

	var name = ""
	var age = ""
	var breed = ""
	var weight = ""
	var temperment = ""
	var specialNeeds = ""
	var lastVaccinated = ""

	var displayName: String = ""
	var note: String = ""
	var postPrivacy = Visibility.pub
	var isSensitive: Bool = false
	var isBot: Bool = false
	var isLocked: Bool = false
	var isDiscoverable: Bool = false
	var fields: [FieldEditViewModel] = []
	var avatar: URL?
	var header: URL?

	var postingProgress: Double = 0.0
	var postingTimer: Timer?
	var isPosting: Bool = false

	var postingError: String?
	var showPostingErrorAlert: Bool = false

	init(mode: Mode) {
		self.mode = mode
	}

	var isPhotoPickerPresented: Bool = false {
		didSet {
			if !isPhotoPickerPresented && mediaPickers.isEmpty {
				isChangingAvatar = false
				isChangingHeader = false
			}
		}
	}
	var isChangingAvatar: Bool = false
	var isChangingHeader: Bool = false

	var isLoading: Bool = true
	var isSaving: Bool = false
	var saveError: Bool = false

	var mediaPickers: [PhotosPickerItem] = [] {
		didSet {
			if let item = mediaPickers.first {
				Task {
					if let data = await getItemImageData(item: item) {
						if isChangingAvatar {
							_ = await uploadAvatar(data: data)
						} else if isChangingHeader {
							_ = await uploadHeader(data: data)
						}
						await fetchAccount()
						isChangingAvatar = false
						isChangingHeader = false
						mediaPickers = []
					}
				}
			}
		}
	}

	func fetchAccount() async {
		guard let client else { return }
		do {
			let account: Account = try await client.get(endpoint: Accounts.verifyCredentials)
			displayName = account.displayName ?? ""
			note = account.source?.note ?? ""
			postPrivacy = account.source?.privacy ?? .pub
			isSensitive = account.source?.sensitive ?? false
			isBot = account.bot
			isLocked = account.locked
			isDiscoverable = account.discoverable ?? false
			avatar = account.avatar
			header = account.header
			fields = account.source?.fields.map { .init(name: $0.name, value: $0.value.asRawText) } ?? []
			withAnimation {
				isLoading = false
			}
		} catch {}
	}

	func setInfo() async {
		guard let client else { return }

		switch mode {
		case let .edit(profile):

			name = profile.name ?? ""
			age = profile.age ?? ""
			breed = profile.breed ?? ""
			weight = profile.weight ?? ""
			temperment = profile.temperment ?? ""
			specialNeeds = profile.specialNeeds ?? ""
			lastVaccinated = profile.lastVaccinated ?? ""
			
			withAnimation {
				isLoading = false
			}
		default:
			withAnimation {
				isLoading = false
			}
			break
		}
	}

	func save() async {
		isSaving = true
		do {
			let data = CreatePetProfileData(name: name, user_id: userID ?? UUID(), age: age, breed: breed, weight: weight, temperment: temperment, specialNeeds: specialNeeds, lastVaccinated: lastVaccinated)

			switch mode {
			case .edit:
				NetWorkManager.makePostRequestWithoutReturn(sending: data,
															path: "users/\(profile!.id!)/profile",
															authType: .bearer
				) { result in
					switch result {
					case .success:
						print("Complete UPDATEPET PROFILE")
						self.isSaving = false
					case .failure(let error):
						print("Failed UPDATE PET PROFILE")
						self.saveError = true
					}
				}
			default:
				NetWorkManager.makePostRequestWithoutReturn(sending: data,
															path: "users/pet",
															authType: .bearer
				) { result in
					switch result {
					case .success:
						print("Complete ADD PET PROFILE")
						self.isSaving = false
					case .failure(let error):
						print("Failed ADD PET PROFILE")
						self.saveError = true
					}
				}
			}
		} catch {
			isSaving = false
			saveError = true
		}
	}

	func saveProfile() async {
		isSaving = true
		do {
			let data = UpdateCredentialsData(displayName: displayName,
											 note: note,
											 source: .init(privacy: postPrivacy, sensitive: isSensitive),
											 bot: isBot,
											 locked: isLocked,
											 discoverable: isDiscoverable,
											 fieldsAttributes: fields.map { .init(name: $0.name, value: $0.value) })
			let response = try await client?.patch(endpoint: Accounts.updateCredentials(json: data))
			if response?.statusCode != 200 {
				saveError = true
			}
			isSaving = false
		} catch {
			isSaving = false
			saveError = true
		}
	}

	func postProfile() async -> PetProfile? {
		guard let client else { return nil }
		do {
				if postingTimer == nil {
					Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
						Task { @MainActor in
							if self.postingProgress < 100 {
								self.postingProgress += 0.5
							}
							if self.postingProgress >= 100 {
								self.postingTimer?.invalidate()
								self.postingTimer = nil
							}
						}
					}
				}

				isSaving = true
				isPosting = true
				var postProfile: PetProfile?

				let data = ProfileDTO(name: name,
								  age: age,
								  breed: breed,
								  weight: weight,
								  temperment: temperment,
								  specialNeeds: specialNeeds,
								  lastVaccinated: lastVaccinated,
								  customerId: accountId ?? "fbb3940a-91a1-46e4-9a4a-f8cdb170cc04")

				switch mode {
				case .new:
//					postProfile = try await client.post(endpoint: Collars.createProfile(json: data))
					NetWorkManager.makePostRequestWithReturn(sending: data,
															receiving: PetProfile.self,
															path: "create-profile",
																authType: .bearer
					) { result in
						switch result {
						case let .success(profile):
							print("Update Pet Profile Completed ---\(profile.name ?? "N/A")")
						case .failure(let error):
							print("Update Pet Profile ERROR ---")
						}
					}
				case let .edit(profile):
//					postStatus = try await client.put(endpoint: Statuses.editStatus(id: status.id, json: data))
//					if let postStatus {
//						StreamWatcher.shared.emmitEditEvent(for: postStatus)
//					}
					NetWorkManager.makePutRequestWithReturn(sending: data,
															receiving: PetProfile.self,
															path: "update-profile/\(profile.id!)",
																authType: .bearer
					) { result in
						switch result {
						case .success:
							print("Update Pet Profile Completed ---")
						case .failure(let error):
							print("Update Pet Profile ERROR ---")
						}
					}
					break
				}

				postingTimer?.invalidate()
				postingTimer = nil

				withAnimation {
					postingProgress = 99.0
				}
				try await Task.sleep(for: .seconds(0.5))
				HapticManager.shared.fireHaptic(.notification(.success))

				isPosting = false
				isSaving = false

				return postProfile
		} catch {
			if let error = error as? ServerError {
				postingError = error.error
				showPostingErrorAlert = true
			}
			isPosting = false
			isSaving = false
			HapticManager.shared.fireHaptic(.notification(.error))
			return nil
		}
	}

	private func uploadHeader(data: Data) async -> Bool {
		guard let client else { return false }
		do {
			let response = try await client.mediaUpload(endpoint: Accounts.updateCredentialsMedia,
														version: .v1,
														method: "PATCH",
														mimeType: "image/jpeg",
														filename: "header",
														data: data)
			return response?.statusCode == 200
		} catch {
			return false
		}
	}

	private func uploadAvatar(data: Data) async -> Bool {
		guard let client else { return false }
		do {
			let response = try await client.mediaUpload(endpoint: Accounts.updateCredentialsMedia,
														version: .v1,
														method: "PATCH",
														mimeType: "image/jpeg",
														filename: "avatar",
														data: data)
			return response?.statusCode == 200
		} catch {
			return false
		}
	}

	private func getItemImageData(item: PhotosPickerItem) async -> Data? {
		//	guard let imageFile = try? await item.loadTransferable(type: StatusEditor.ImageFileTranseferable.self) else { return nil }
		//
		//	let compressor = StatusEditor.Compressor()
		//
		//	guard let compressedData = await compressor.compressImageFrom(url: imageFile.url),
		//			let image = UIImage(data: compressedData),
		//			let uploadData = try? await compressor.compressImageForUpload(image)
		//	else { return nil }
		//
		//	return uploadData
		return nil
	}
}

