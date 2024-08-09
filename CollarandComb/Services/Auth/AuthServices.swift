//
//  AuthServices.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/14/23.
//

import Foundation

/// #A service that handles user authentication.
/// ##Holds the token used to perform authorization in requests.
final class AuthService: ObservableObject {
	@Published var isLoggedIn = false

	/// The keychain identifier for token storage.
	private let keychainKey = "COLLAR-AND-FOAM-API-KEY"

	/// The token used to authorize requests.
	/// A value for the token means that the user is signed in.
	/// If the token is nil then the user's session expired.
	var token: String? {
		get {
		  Keychain.load(key: keychainKey)
		}
		set {
		  if let newToken = newValue {
			Keychain.save(key: keychainKey, data: newToken)
		  } else {
			Keychain.delete(key: keychainKey)
		  }
		}
	}

	/// The shared singleton instance of this service.
	static let shared = AuthService()

	/// The private initializer for this service.
	init() {}
}

extension AuthService: AuthServiceProtocol {



	/// Makes a network request to check whether an email address is available for use in account creation.
	/// - Parameters:
	///   - email: The email address to check availability for.
	///   - completion: A closure the method runs when a result is received from the request.
	///                 The closure takes a boolean value that indicates whether the email address is available or not.
	func checkEmailAvailability(email: String, completion: @escaping AvailabilityHandler) {
		let validationData = User.ValidateData(email: email)

		NetWorkManager.makePostRequestWithoutReturn(
			sending: validationData,
			path: "users/validate",
			authType: .none
		) { result in
			switch result {
			case .success:
				completion(true)
			case .failure:
				completion(false)
			}
		}
	}

	/// Makes a network request to sign up a user using the email address and the password provided.
	/// - Parameters:
	///   - email: The email address to sign the user up with.
	///   - password: The password to authenticate the user with.
	///   - completion: A closure the method runs when a result is received from the request.
	///                 The closure takes an `AuthResult` value that indicates
	///                 whether the sign-up was successful or not.
	func signUp(email: String, firstName: String, lastName: String, password: String, completion: @escaping AuthResultHandler) {
//		let user = User(id: UUID(), 
//						emailAddress: email,
//						bio: nil,
//						firstName: firstName,
//						lastName: lastName,
//						profileURL: nil,
//						isVerified: false,
//						isAdmin: false,
////						orderHistory: nil,
////						favoriteProducts: nil,
//						petProfile: nil,
//						password: password,
//						phoneNumber: nil)

		let user = CustomerDTO(
			username: email,
			firstName: firstName,
			lastName: lastName,
			email: email,
			password: password)

		NetWorkManager.makePostRequestWithReturn(
			sending: user,
			receiving: String.self,
			path: "create-customer",
			authType: .none
		) { result in
			switch result {
			case .success(let token):
				self.token = token
				self.isLoggedIn = true
				completion(.success)

			case .failure:
				completion(.failure)
			}
		}
	}

	/// Makes a network request to sign in a user using the email address and the password provided
	/// - Parameters:
	///   - email: The email address to sign the user in with.
	///   - password: The password to authenticate the user with.
	///   - completion: A closure the method runs when a result is received from the request.
	///                 The closure takes an `AuthResult` value that indicates
	///                 whether the sign-in was successful or not.
	///
	///
	///
//	(id: UUID?, username: String, email: String, pic: String?, bio: String?, firstName: String, lastName: String?, todos: [Todo]?, buckets: [Bucket]?)
	func signIn(username: String, password: String, completion: @escaping AuthResultHandler) {
		guard let loginString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
			completion(.failure)
			return
		}

		NetWorkManager.makePostRequestWithReturn(
			sending: "",
			receiving: Token.self,
			path: "users/login",
			authType: .basic(value: loginString)
		) { result in
			switch result {
			case .success(let token):
				self.token = token.value
				completion(.success)

			case .failure:
				completion(.failure)
			}
		}
	}
}

