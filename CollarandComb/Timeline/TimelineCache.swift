//
//  TimelineCache.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Network
import SwiftUI
import Bodega

actor TimelineCache {
	private func storageFor(_ client: String, _ filter: String) -> SQLiteStorageEngine {
		if filter == "Home" {
			SQLiteStorageEngine.default(appendingPath: "\(client)")
		} else {
			SQLiteStorageEngine.default(appendingPath: "\(client)/\(filter)")
		}
	}

	private let decoder = JSONDecoder()
	private let encoder = JSONEncoder()

	init() {}

	func cachedPostsCount(for client: String) async -> Int {
		do {
			let directory = FileManager.Directory.defaultStorageDirectory(appendingPath: client).url
			let content = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
			var total: Int = await storageFor(client, "Home").allKeys().count
			for storage in content {
				if !storage.lastPathComponent.hasSuffix("sqlite3") {
					total += await storageFor(client, storage.lastPathComponent).allKeys().count
				}
			}
			return total
		} catch {
			return 0
		}
	}

	func clearCache(for client: String) async {
		let directory = FileManager.Directory.defaultStorageDirectory(appendingPath: client)
		try? FileManager.default.removeItem(at: directory.url)
	}

	func clearCache(for client: String, filter: String) async {
		let engine = storageFor(client, filter)
		do {
			try await engine.removeAllData()
		} catch {}
	}

	func set(statuses: [Product], client: String, filter: String) async {
		guard !statuses.isEmpty else { return }
		let statuses = statuses.prefix(upTo: min(600, statuses.count - 1)).map { $0 }
		do {
			let engine = storageFor(client, filter)
			try await engine.removeAllData()
			let itemKeys = statuses.map { CacheKey($0[keyPath: \.id!.uuidString]) }
			let dataAndKeys = try zip(itemKeys, statuses)
				.map { try (key: $0, data: encoder.encode($1)) }
			try await engine.write(dataAndKeys)
		} catch {}
	}

	func getStatuses(for client: String, filter: String) async -> [Product]? {
		let engine = storageFor(client, filter)
		do {
			return try await engine
				.readAllData()
				.map { try decoder.decode(Product.self, from: $0) }
//				.sorted(by: { $0.createdAt > $1.createdAt })
		} catch {
			return nil
		}
	}

	func setLatestSeenStatuses(_ products: [Product], for client: Client, filter: String) {
//		let products = products.sorted(by: { $0.createdAt > $1.createdAt })
		if filter == "Home" {
			UserDefaults.standard.set(products.map{ $0.id!.uuidString }, forKey: "timeline-last-seen-\(client.id)")
		} else {
			UserDefaults.standard.set(products.map{ $0.id!.uuidString }, forKey: "timeline-last-seen-\(client.id)-\(filter)")
		}
	}

	func getLatestSeenStatus(for client: Client, filter: String) -> [String]? {
		if filter == "Home" {
			UserDefaults.standard.array(forKey: "timeline-last-seen-\(client.id)") as? [String]
		} else {
			UserDefaults.standard.array(forKey: "timeline-last-seen-\(client.id)-\(filter)") as? [String]
		}
	}
}

// Quiets down the warnings from this one. Bodega is nicely async so we don't
// want to just use `@preconcurrency`, but the CacheKey type is (incorrectly)
// not marked as `Sendable`---it's a value type containing two `String`
// properties.
extension Bodega.CacheKey: @unchecked Sendable {}

