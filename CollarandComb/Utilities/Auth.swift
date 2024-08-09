//
//  Auth.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/15/23.
//

import Foundation
import UIKit


final class Auth {
  static let keychainKey = "COLLAR-AND-FOAM-API-KEY"
	let domainRoot = "https://caf-vapor-api-c922eaf44828.herokuapp.com"
	let nodeDomainRoot = "https://node-db-collar-club-9d8f9fa7d4eb.herokuapp.com/api"

	var me: User? = nil

  var token: String? {
	get {
	  Keychain.load(key: Auth.keychainKey)
	}
	set {
	  if let newToken = newValue {
		Keychain.save(key: Auth.keychainKey, data: newToken)
	  } else {
		Keychain.delete(key: Auth.keychainKey)
	  }
	}
  }

  func logout() {
	token = nil
//	DispatchQueue.main.async {
//	  guard let applicationDelegate =
//		UIApplication.shared.delegate as? AppDelegate else {
//		  return
//	  }
//	  let rootController =
//		UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginNavigation")
//	  applicationDelegate.window?.rootViewController = rootController
//	}
  }


//  func login(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
//	let path = "\(nodeDomainRoot)/login"
//	guard let url = URL(string: path) else {
//	  fatalError("Failed to convert URL")
//	}
//	guard
//	  let loginString = "\(email):\(password)"
//		.data(using: .utf8)?
//		.base64EncodedString()
//	else {
//	  fatalError("Failed to encode credentials")
//	}
//
//	var loginRequest = URLRequest(url: url)
//	loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
//	loginRequest.httpMethod = "POST"
//
//	let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
//	  guard
//		let httpResponse = response as? HTTPURLResponse,
//		httpResponse.statusCode == 200,
//		let jsonData = data
//	  else {
//		completion(.failure)
//		return
//	  }
//
//	  do {
//		let token = try JSONDecoder().decode(String.self, from: jsonData)
//		self.token = token
//		completion(.success)
//		print("IT'S A GO")
//	  } catch {
//		completion(.failure)
//	  }
//	}
//	dataTask.resume()
//  }

	func login(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
		let path = "\(nodeDomainRoot)/login"
		guard let url = URL(string: path) else {
			fatalError("Failed to convert URL")
		}

		// Create a dictionary for the request body
		let requestBody: [String: Any] = [
			"email": email,
			"password": password
		]

		// Convert request body to JSON data
		guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
			fatalError("Failed to encode request body")
		}

		var loginRequest = URLRequest(url: url)
		loginRequest.httpMethod = "POST"
		loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		loginRequest.httpBody = jsonData

		let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure)
				return
			}

			// Check if the response status code is 200 (OK)
			if httpResponse.statusCode == 200 {
				// Handle successful login response
				if let jsonData = data {
					do {
						// Decode the token from JSON response
						let token = try JSONDecoder().decode(String.self, from: jsonData)
						// Assuming `self.token` is the property to store the token
						self.token = token
						completion(.success)
						print("IT'S A GO")
					} catch {
						// Failed to decode token
						completion(.failure)
					}
				} else {
					// No data received
					completion(.failure)
				}
			} else {
				// Handle other status codes
				completion(.failure)
			}
		}
		dataTask.resume()
	}


  func login(signInWithAppleInformation: SignInWithAppleToken, completion: @escaping (AuthResult) -> Void) throws {
	let path = "\(domainRoot)/api/users/siwa"
	guard let url = URL(string: path) else {
	  fatalError("Failed to convert URL")
	}
	var loginRequest = URLRequest(url: url)
	loginRequest.httpMethod = "POST"
	loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
	loginRequest.httpBody = try JSONEncoder().encode(signInWithAppleInformation)

	let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
	  guard
		let httpResponse = response as? HTTPURLResponse,
		httpResponse.statusCode == 200,
		let jsonData = data
	  else {
		completion(.failure)
		return
	  }

	  do {
		let token = try JSONDecoder().decode(Token.self, from: jsonData)
		self.token = token.value
		completion(.success)
	  } catch {
		completion(.failure)
	  }
	}
	dataTask.resume()
  }
}

struct SignInWithAppleToken: Codable {
  let token: String
  let name: String?
}


