//
//  UserClient.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/31/23.
//

import Foundation
import ComposableArchitecture
import class SwiftUI.UIImage

extension DependencyValues {
	var userClient: UserClient {
		get { self[UserClient.self] }
		set { self[UserClient.self] = newValue }
	}
}

struct UserClient {
	// swiftlint:disable line_length
	// MARK: - Networking
	let createPetProfile: (CreatePetProfileData) -> Void
	let getProfiles: (Int, Int) -> EffectPublisher<ResponseData<[PetProfile]>, AppError>
	let deletePetProfile: (String) -> Void
	let updatePetProfile: (CreatePetProfileData, String) -> Void
}

extension UserClient {
	// MARK: - Manage info for offline reading
	private static func getCoverArtName(mangaID: UUID) -> String {
		"coverArt-\(mangaID.uuidString.lowercased())"
	}
	private static func getChapterPageName(chapterID: UUID, pageIndex: Int) -> String {
		"\(chapterID.uuidString.lowercased())-\(pageIndex)"
	}
}

extension UserClient: DependencyKey {
	static let liveValue = UserClient(
		createPetProfile: { profile in

			NetWorkManager.makePostRequestWithoutReturn(sending: profile,
														path: "users/pet",
														authType: .bearer
			) { result in
				switch result {
				case .success:
					print("Complete ADD PET PROFILE")
				case .failure(let error):
					print("Failed ADD PET PROFILE")
				}
			}

		},
		getProfiles: { limit, page in

			var components = URLComponents()
			components.scheme = "https"
			components.host = "caf-vapor-api-c922eaf44828.herokuapp.com"
			components.path = "/users/profiles"
			components.queryItems = [
				URLQueryItem(name: "limit", value: "\(limit)"),
				URLQueryItem(name: "page", value: "\(page)"),
			]

			guard let url = components.url else {
				return .none
			}

			guard let token = AuthService.shared.token else {
				return .none
			}

			return URLSession.shared.get(url: url, token: token, decodeResponseAs:  ResponseData<[PetProfile]>.self)

		},
		deletePetProfile: { uuid in
			NetWorkManager.deletePostRequestWithoutReturn(sending: uuid,
														path: "users/\(uuid)/profile",
														authType: .bearer
			) { result in
				switch result {
				case .success:
					print("Delete Pet Profile Completed ---")
				case .failure(let error):
					print("Delete Pet Profile ERROR ---")
				}
			}

		},
		updatePetProfile: { profile, uuid in
			NetWorkManager.makePutRequestWithoutReturn(sending: profile,
														  path: "users/\(uuid)/profile",
														authType: .bearer
			) { result in
				switch result {
				case .success:
					print("Update Pet Profile Completed ---")
				case .failure(let error):
					print("Update Pet Profile ERROR ---")
				}
			}

		}
	)
}


