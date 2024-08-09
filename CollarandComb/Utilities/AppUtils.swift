//
//  AppUtils.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/25/23.
//

import Foundation

enum AppUtil {
	static var version: String {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "null"
	}

	static var build: String {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "null"
	}

	static var dateFormatter: DateFormatter = {
		let fmt = DateFormatter()

		fmt.locale = Locale(identifier: "en_US_POSIX")
		fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+00:00"
		fmt.timeZone = .init(identifier: "UTC")

		return fmt
	}()

	static var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(AppUtil.dateFormatter)
		return decoder
	}()

	static var encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(AppUtil.dateFormatter)
		return encoder
	}()
}

