//
//  NetworkManager.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/14/23.
//
import Foundation

protocol NetworkManagerProtocol {
	static func makeGetRequest<T: Decodable>(
		_ type: T.Type,
		path: String,
		authType: RequestAuthType,
		completion:    @escaping (Result<T, RequestError>) -> Void
	)
}

enum RequestAuthType {
	case none,
		 basic(value: String),
		 bearer
}

struct NetWorkManager: NetworkManagerProtocol {
	private static let authService = AuthService.shared
	static func makeGetRequest<T: Decodable>(
		_ type: T.Type,
		path: String,
		authType: RequestAuthType,
		completion:    @escaping (Result<T, RequestError>) -> Void
	) {
		DispatchQueue.global(qos: .userInteractive).async {
			guard let url    =    API.nodeBaseURL?.appendingPathComponent(path)    else {
				DispatchQueue.main.async {
					completion(.failure(.invalidURL))
				}
				return
			}
			var request = URLRequest(url: url)
			request.httpMethod  =   "GET"
			request.setValue("application/json", forHTTPHeaderField: "Content-type")

			switch authType {
			case .none:
				break
			case .basic(let value):
				request.addValue("Basic \(value)", forHTTPHeaderField: "Authorization")
			case .bearer:
				guard let token = AuthService.shared.token else {
					DispatchQueue.main.async {
						completion(.failure(.unauthorizedRequest))
					}
					return
				}
				request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			}

			URLSession.shared.dataTask(with: request) { data, _, _ in
				guard let data    =    data else {
					DispatchQueue.main.async {
						completion(.failure(.invalidDataFromServer))
					}
					return
				}
				guard let decoded    =    try? JSONDecoder().decode(T.self, from: data)    else {
					DispatchQueue.main.async {
						completion(.failure(.failedToDecodeData))
					}
					return
				}
				DispatchQueue.main.async {
					completion(.success(decoded))
				}

			}.resume()
		}
	}

	static func makePostRequestWithReturn<SendData: Encodable, ReceiveData: Decodable>(
		sending payload: SendData,
		receiving: ReceiveData.Type,
		path: String,
		authType: RequestAuthType,
		completion: @escaping (Result<ReceiveData, RequestError>) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			guard let url    =    API.nodeBaseURL?.appendingPathComponent(path)    else {
				DispatchQueue.main.async {
					completion(.failure(.invalidURL))
				}
				return
			}
			var request = URLRequest(url: url)
			request.httpMethod  =   "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-type")
			switch authType {
			case .none:
				break
			case .basic(let value):
				request.addValue("Basic \(value)", forHTTPHeaderField: "Authorization")
			case .bearer:
				guard let token = AuthService.shared.token else {
					DispatchQueue.main.async {
						completion(.failure(.unauthorizedRequest))
					}
					return
				}
				request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			}
			request.httpBody = try? JSONEncoder().encode(payload)

			URLSession.shared.dataTask(with: request) { data, _, _ in
				guard let data    =    data else {
					DispatchQueue.main.async {
						completion(.failure(.invalidDataFromServer))
					}
					return
				}
				guard let decoded    =    try? JSONDecoder().decode(ReceiveData.self, from: data)    else {
					DispatchQueue.main.async {
						completion(.failure(.failedToDecodeData))
					}
					return
				}
				DispatchQueue.main.async {
					completion(.success(decoded))
				}
			}.resume()
		}
	}

	static func makePutRequestWithReturn<SendData: Encodable, ReceiveData: Decodable>(
		sending payload: SendData,
		receiving: ReceiveData.Type,
		path: String,
		authType: RequestAuthType,
		completion: @escaping (Result<ReceiveData, RequestError>) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			guard let url = API.nodeBaseURL?.appendingPathComponent(path) else {
				DispatchQueue.main.async {
					completion(.failure(.invalidURL))
				}
				return
			}
			var request = URLRequest(url: url)
			request.httpMethod = "PUT"
			request.setValue("application/json", forHTTPHeaderField: "Content-type")
			switch authType {
			case .none:
				break
			case .basic(let value):
				request.addValue("Basic \(value)", forHTTPHeaderField: "Authorization")
			case .bearer:
				guard let token = AuthService.shared.token else {
					DispatchQueue.main.async {
						completion(.failure(.unauthorizedRequest))
					}
					return
				}
				request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			}
			request.httpBody = try? JSONEncoder().encode(payload)

			URLSession.shared.dataTask(with: request) { data, _, _ in
				guard let data    =    data else {
					DispatchQueue.main.async {
						completion(.failure(.invalidDataFromServer))
					}
					return
				}
				guard let decoded    =    try? JSONDecoder().decode(ReceiveData.self, from: data)    else {
					DispatchQueue.main.async {
						completion(.failure(.failedToDecodeData))
					}
					return
				}
				DispatchQueue.main.async {
					completion(.success(decoded))
				}
			}.resume()
		}
	}

	static func makePostRequestWithoutReturn<SendData: Encodable>(
		sending payload: SendData,
		path: String,
		authType: RequestAuthType,
		completion: @escaping (Result<Void, RequestError>) -> Void
	) {
		DispatchQueue.global(qos: .userInteractive).async {
			guard let url    =    API.nodeBaseURL?.appendingPathComponent(path)    else {
				DispatchQueue.main.async {
					completion(.failure(.invalidURL))
				}
				return
			}
			var request = URLRequest(url: url)
			request.httpMethod  =   "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-type")
			switch authType {
			case .none:
				break
			case .basic(let value):
				request.addValue("Basic \(value)", forHTTPHeaderField: "Authorization")
			case .bearer:
				guard let token = AuthService.shared.token else {
					DispatchQueue.main.async {
						completion(.failure(.unauthorizedRequest))
					}
					return
				}
				request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			}
			request.httpBody = try? JSONEncoder().encode(payload)

			URLSession.shared.dataTask(with: request) { _, response, _ in
				guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
					DispatchQueue.main.async {
						completion(.failure(.invalidResponseFromServer))
					}
					return
				}
				DispatchQueue.main.async {
					completion(.success(()))
				}
			}.resume()
		}
	}

	static func makePutRequestWithoutReturn<SendData: Encodable>(
		sending payload: SendData,
		path: String,
		authType: RequestAuthType,
		completion: @escaping (Result<Void, RequestError>) -> Void
	) {
		DispatchQueue.global(qos: .userInteractive).async {
			guard let url    =    API.baseURL?.appendingPathComponent(path)    else {
				DispatchQueue.main.async {
					completion(.failure(.invalidURL))
				}
				return
			}
			var request = URLRequest(url: url)
			request.httpMethod  =   "PUT"
			request.setValue("application/json", forHTTPHeaderField: "Content-type")
			switch authType {
			case .none:
				break
			case .basic(let value):
				request.addValue("Basic \(value)", forHTTPHeaderField: "Authorization")
			case .bearer:
				guard let token = AuthService.shared.token else {
					DispatchQueue.main.async {
						completion(.failure(.unauthorizedRequest))
					}
					return
				}
				request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			}
			request.httpBody = try? JSONEncoder().encode(payload)

			URLSession.shared.dataTask(with: request) { _, response, _ in
				guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
					DispatchQueue.main.async {
						completion(.failure(.invalidResponseFromServer))
					}
					return
				}
				DispatchQueue.main.async {
					completion(.success(()))
				}
			}.resume()
		}
	}

	static func deletePostRequestWithoutReturn<SendData: Encodable>(
		sending payload: SendData,
		path: String,
		authType: RequestAuthType,
		completion: @escaping (Result<Void, RequestError>) -> Void
	) {
		DispatchQueue.global(qos: .userInteractive).async {
			guard let url    =    API.nodeBaseURL?.appendingPathComponent(path)    else {
				DispatchQueue.main.async {
					completion(.failure(.invalidURL))
				}
				return
			}
			var request = URLRequest(url: url)
			request.httpMethod  =   "DELETE"
			request.setValue("application/json", forHTTPHeaderField: "Content-type")
			switch authType {
			case .none:
				break
			case .basic(let value):
				request.addValue("Basic \(value)", forHTTPHeaderField: "Authorization")
			case .bearer:
				guard let token = AuthService.shared.token else {
					DispatchQueue.main.async {
						completion(.failure(.unauthorizedRequest))
					}
					return
				}
				request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			}
			request.httpBody = try? JSONEncoder().encode(payload)

			URLSession.shared.dataTask(with: request) { _, response, _ in
				guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
					DispatchQueue.main.async {
						completion(.failure(.invalidResponseFromServer))
					}
					return
				}
				DispatchQueue.main.async {
					completion(.success(()))
				}
			}.resume()
		}
	}

}


