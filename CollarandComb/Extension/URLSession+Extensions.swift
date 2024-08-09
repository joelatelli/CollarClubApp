//
//  URLSession.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/25/23.
//

import Foundation
import struct ComposableArchitecture.EffectPublisher
import ComposableArchitecture

extension URLSession {
	func get<T: Decodable>(url: URL, decodeResponseAs _: T.Type, decoder: JSONDecoder = AppUtil.decoder) -> EffectPublisher<T, AppError> {
		var request = URLRequest(url: url)

		let userAgent = "Collar-and-Foam/\(AppUtil.version) (\(DeviceUtil.deviceName); \(DeviceUtil.fullOSName))"
		request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
		request.timeoutInterval = 15
		request.cachePolicy = .reloadIgnoringLocalCacheData

		return URLSession.shared.dataTaskPublisher(for: request)
			.validateResponseCode()
			.retry(2)
			.map(\.data)
			.decode(type: T.self, decoder: decoder)
			.mapError { err -> AppError in
				if let err = err as? URLError {
					return .networkError(err)
				} else if let err = err as? DecodingError {
					return .decodingError(err)
				}

				return .unknownError(err)
			}
			.eraseToEffect()
	}

	func get<T: Decodable>(url: URL, token: String?, decodeResponseAs type: T.Type) -> EffectPublisher<T, AppError> {
		let decoder2 = JSONDecoder()
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		if let token = token {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}

		let session = URLSession.shared

		return session.dataTaskPublisher(for: request)
			.mapError { err -> AppError in
				if let err = err as? URLError {
					return .networkError(err)
				} else if let err = err as? DecodingError {
					return .decodingError(err)
				}

				return .unknownError(err)
			}
			.flatMap(maxPublishers: .max(1)) { (data, response) -> Effect<T, AppError> in
				guard let httpResponse = response as? HTTPURLResponse else {
					return .none
				}
				guard (200...299).contains(httpResponse.statusCode) else {
					return .init(error: .notFound)
				}

				do {
					let decodedResponse = try decoder2.decode(T.self, from: data)
					return .init(value: decodedResponse)
				} catch {
					return .init(error: .notFound)
				}
			}
			.eraseToEffect()
	}
}
