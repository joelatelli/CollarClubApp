//
//  Collars.swift
//  CollarandComb
//
//  Created by Joel Muflam on 2/9/24.
//

import Foundation

enum Collars: Endpoint {
	case profiles(limit: Int, page: Int)
	case myProfiles(id: String, limit: Int, page: Int)
	case create
	case createProfile(json: ProfileDTO)
	case editProfile(json: ProfileDTO)
	case clear
	case deleteProfile(id: String)

	public func path() -> String {
		switch self {
		case let .myProfiles(id, _, _):
			"\(id)/profiles"
		case .profiles:
			"profile"
		case .create:
			"users/pet"
		case .createProfile:
			"create-profile"
		case .editProfile:
			"update-profile"
		case .clear:
			"notifications/clear"
		case let .deleteProfile(id):
			"delete-profile/\(id)"
		}
	}

	public func queryItems() -> [URLQueryItem]? {
		switch self {
		case let .profiles(limit, page):
			let params = [
				URLQueryItem(name: "limit", value: "\(limit)"),
				URLQueryItem(name: "page", value: "\(page)")
			]
			return params
		default:
			return nil
		}
	}

	var jsonValue: Encodable? {
		switch self {
		case let .createProfile(json):
			json
		case let .editProfile(json):
			json
		default:
			nil
		}
	}
}
