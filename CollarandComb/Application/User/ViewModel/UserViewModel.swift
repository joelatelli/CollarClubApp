//
//  UserViewModel.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/14/23.
//

import Foundation
import Combine
import SwiftUI

class UserViewModel: ObservableObject {

	public static let shared = UserViewModel()

	@Published var currentPageWasRetapped = false
	@Published private(set) var homeScreenIsReady = false

	/// Tracks whether the todo is currently being modified.
	@Published var isModifying = false


	@Published var me: User = User.placeholder()

	@Published var favoriteProducts = [Product2]()
	@Published var petProfiles = [PetProfile]()

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
					self.me = user
//					self.favoriteProducts = user.favoriteProducts ?? []
					self.petProfiles = user.petProfile ?? []
					print("COUNT -- \(self.petProfiles.count)")
//					self.username = user.username
//					self.bio = user.bio ?? ""
//					self.firstName = user.firstName
//					self.lastName = user.lastName ?? ""
//					self.pic = user.pic ?? ""
//					self.fetchMySavedTodos(userID: user.id!.uuidString)
//					self.fetchMySavedBuckets(userID: user.id!.uuidString)
				}
			} catch {
				print("failed to decode user object")
			}
		}

		self.homeScreenIsReady = true
		result.resume()
	}

}


