//
//  CurrentUser.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import Combine
import Foundation
import Network
import Observation

@MainActor
@Observable class CurrentUser {
	private static var accountsCache: [String: Account] = [:]

	private(set) var user: User?
	private(set) var account: Account?
	private(set) var isUpdating: Bool = false
	private(set) var isLoadingAccount: Bool = false

	static let shared = CurrentUser()

	func setMe() {
		let url = URL(string: "\(Constants.nodeBaseURL)/auth/\(Auth().token ?? "")")
		var urlReq = URLRequest(url: url!)

		urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
		urlReq.setValue("Bearer \(Auth().token ?? "")", forHTTPHeaderField: "Authorization")
		urlReq.httpMethod = "GET"
		let result = URLSession.shared.dataTask(with: urlReq) { (data, resp, err) in

			print("SetMe finished")
			guard let gotData = data else {
				print("Failed to get data")
				return
			}

			do {
				let decoder = JSONDecoder()
				let user = try decoder.decode(User.self, from: gotData)

				DispatchQueue.main.async {
					self.user = user
//					self.favoriteProducts = user.favoriteProducts ?? []
//					self.petProfiles = user.petProfile ?? []
//					print("COUNT -- \(self.petProfiles.count)")

				}
			} catch {
				print("failed to decode user object")
			}
		}

//		self.homeScreenIsReady = true
		result.resume()
	}
}
