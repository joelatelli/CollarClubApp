//
//  ProductClient.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/16/23.
//

import Foundation
import ComposableArchitecture
import class SwiftUI.UIImage

extension DependencyValues {
	var productClient: ProductClient {
		get { self[ProductClient.self] }
		set { self[ProductClient.self] = newValue }
	}
}

struct ProductClient {
	// swiftlint:disable line_length
	// MARK: - Networking

	let favoriteProduct: (UUID) -> Void
	let unfavoriteProduct: (UUID) -> Void
	let fetchUserFavorites: (String, Int, Int) -> EffectPublisher<ResponseData<[Product]>, AppError>
	let fetchMeUser: () -> EffectPublisher<ResponseData<User>, AppError>
	let fetchProducts: (Int, Int) -> EffectPublisher<ResponseData<[Product]>, AppError>

}

extension ProductClient {
	// MARK: - Manage info for offline reading
	private static func getCoverArtName(mangaID: UUID) -> String {
		"coverArt-\(mangaID.uuidString.lowercased())"
	}
	private static func getChapterPageName(chapterID: UUID, pageIndex: Int) -> String {
		"\(chapterID.uuidString.lowercased())-\(pageIndex)"
	}
}

extension ProductClient: DependencyKey {
	static let liveValue = ProductClient(
		favoriteProduct: { productID in
			NetWorkManager.makePostRequestWithoutReturn(sending: productID,
														path: "users/favorite/\(productID)",
														authType: .bearer
			) { result in
				switch result {
				case .success:
					print("PARTICIPATING ---")
//					completion(.success(()))
				case .failure(let error):
//					completion(.failure(error))
					print("")
				}
			}
		},
		unfavoriteProduct: { productID in
			NetWorkManager.makePostRequestWithoutReturn(sending: productID,
														path: "users/unfavorite/\(productID)",
														authType: .bearer
			) { result in
				switch result {
				case .success:
					print("PARTICIPATING ---")
//					completion(.success(()))
				case .failure(let error):
//					completion(.failure(error))
					print("")
				}
			}
		},
		fetchUserFavorites: { userID, limit, page in

			var components = URLComponents()
			components.scheme = "https"
			components.host = "caf-vapor-api-c922eaf44828.herokuapp.com"
			components.path = "/users/\(userID)/favorites"
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

			return URLSession.shared.get(url: url, token: token, decodeResponseAs:  ResponseData<[Product]>.self)

		},
		fetchMeUser: {

			var components = URLComponents()
			components.scheme = "https"
			components.host = "caf-vapor-api-c922eaf44828.herokuapp.com"
			components.path = "/users/me/"
			components.queryItems = [
				URLQueryItem(name: "limit", value: "25"),
			]

			guard let url = components.url else {
				return .none
			}

			guard let token = AuthService.shared.token else {
				return .none
			}

			return URLSession.shared.get(url: url, token: token, decodeResponseAs:  ResponseData<User>.self)

		},
		fetchProducts: { limit, page in

			var components = URLComponents()
			components.scheme = "https"
			components.host = "caf-vapor-api-c922eaf44828.herokuapp.com"
			components.path = "/products/"
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

			return URLSession.shared.get(url: url, token: token, decodeResponseAs:  ResponseData<[Product]>.self)

		}
	)
}

