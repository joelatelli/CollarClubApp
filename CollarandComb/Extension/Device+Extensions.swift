//
//  Device.swift
//  CollarandComb
//
//  Created by Joel Muflam on 9/6/23.
//

import Foundation
import SwiftUI


extension Device {
	static func current() -> Device? {
		guard let data = FileManager.default.contents(atPath: currentDeviceURL.path) else {
			return nil
		}

		return try! JSONDecoder().decode(Device.self, from: data)
	}

	static func saveNew() {
		//		let updateDevice = UpdateDevice(system: .iOS, osVersion: UIDevice.current.systemVersion)
		print("DEVICEEEE saveNew()")
		let updateDevice = UpdateDevice(pushToken: Device.current()?.pushToken, system: .iOS, osVersion: UIDevice.current.systemVersion)

		save(with: updateDevice)
	}

	func save(completion: ((Bool) -> Void)? = nil) {
		let updateDevice = UpdateDevice(id: id,
										pushToken: pushToken,
										system: system,
										osVersion: osVersion)
		
		Device.save(with: updateDevice, completion: completion)
	}

	private static func save(with updateDevice: UpdateDevice, completion: ((Bool) -> Void)? = nil) {
		print("DEVICEEEE")
		print("DEVICEEEE \(updateDevice)")
		URLSession.shared.jsonDecodableDataTask(of: Device.self, url: URL(string: "\(Constants.baseURL)devices/update")!, httpMethod: "PUT", body: try? JSONEncoder().encode(updateDevice)) {
			switch $0 {
			case .success(let device):
				print("Device updated successfully: \(device)")
				device.persist()
				completion?(true)
			case .failure(let error):
				print("Failure updating device: \(error)")
				completion?(false)
			}
		}
	}

	private func persist() {
		let data = try! JSONEncoder().encode(self)
		try! data.write(to: Device.currentDeviceURL)
	}

	private static var currentDeviceURL: URL {
		getDocumentsDirectory().appendingPathComponent("CurrentDevice.swift")
	}

	private static func getDocumentsDirectory() -> URL {
		FileManager.default
			.urls(for: .documentDirectory, in: .userDomainMask)
			.first!
	}
}

extension URLSession {
	@discardableResult
	func jsonDecodableDataTask<D: Decodable>(of type: D.Type,
											 url: URL,
											 httpMethod: String = "GET",
											 body: Data? = nil,
											 decoder: JSONDecoder = JSONDecoder(),
											 completionHandler: @escaping ((Result<D, Error>) -> Void)) -> URLSessionTask {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod
		request.httpBody = body
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

		let task = dataTask(with: request) { data, _, error in
			if let error = error {
				completionHandler(.failure(error))
				return
			}

			guard let data = data else {
				completionHandler(.failure(URLError(URLError.cannotDecodeContentData)))
				return
			}

			do {
				let decoder = decoder
				let result = try decoder.decode(type.self, from: data)
				completionHandler(.success(result))
			} catch {
				completionHandler(.failure(error))
			}
		}
		task.resume()
		return task
	}
}
