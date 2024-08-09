//
//  Products.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Foundation

enum Products: Endpoint {
	case fetchAll(limit: Int, page: Int)
	case postProduct(json: ProductData)
	case editProduct(id: String, json: ProductData)
	case status(id: String)
	case context(id: String)
	case favorite(id: String)
	case unfavorite(id: String)
	case reblog(id: String)
	case unreblog(id: String)
	case rebloggedBy(id: String, maxId: String?)
	case favoritedBy(id: String, maxId: String?)
	case pin(id: String)
	case unpin(id: String)
	case bookmark(json: FavoriteDTO)
	case unbookmark(id: String)
	case history(id: String)
	case translate(id: String, lang: String?)
	case report(accountId: String, statusId: String, comment: String)

	func path() -> String {
		switch self {
		case .fetchAll:
			"products"
		case .postProduct:
			"statuses"
		case let .status(id):
			"statuses/\(id)"
		case let .editProduct(id, _):
			"statuses/\(id)"
		case let .context(id):
			"statuses/\(id)/context"
		case let .favorite(id):
			"statuses/\(id)/favourite"
		case let .unfavorite(id):
			"statuses/\(id)/unfavourite"
		case let .reblog(id):
			"statuses/\(id)/reblog"
		case let .unreblog(id):
			"statuses/\(id)/unreblog"
		case let .rebloggedBy(id, _):
			"statuses/\(id)/reblogged_by"
		case let .favoritedBy(id, _):
			"statuses/\(id)/favourited_by"
		case let .pin(id):
			"statuses/\(id)/pin"
		case let .unpin(id):
			"statuses/\(id)/unpin"
		case let .bookmark(id):
			"favorite-product"
		case let .unbookmark(id):
			"statuses/\(id)/unbookmark"
		case let .history(id):
			"statuses/\(id)/history"
		case let .translate(id, _):
			"statuses/\(id)/translate"
		case .report:
			"reports"
		}
	}

	func queryItems() -> [URLQueryItem]? {
		switch self {
		case let .fetchAll(limit, page):
			let params = [
				URLQueryItem(name: "limit", value: "\(limit)"),
				URLQueryItem(name: "page", value: "\(page)"),
			]
			return params
		case let .rebloggedBy(_, maxId):
			return makePaginationParam(sinceId: nil, maxId: maxId, mindId: nil)
		case let .favoritedBy(_, maxId):
			return makePaginationParam(sinceId: nil, maxId: maxId, mindId: nil)
		case let .translate(_, lang):
			if let lang {
				return [.init(name: "lang", value: lang)]
			}
			return nil
		case let .report(accountId, statusId, comment):
			return [.init(name: "account_id", value: accountId),
					.init(name: "status_ids[]", value: statusId),
					.init(name: "comment", value: comment)]
		default:
			return nil
		}
	}

	var jsonValue: Encodable? {
		switch self {
		case let .postProduct(json):
			json
		case let .editProduct(_, json):
			json
		case let .bookmark(json):
			json
		default:
			nil
		}
	}
}

struct ProductData: Encodable, Sendable {

	let id: UUID?
	let title: String
	let price: Double
	let desc: String
	let imageURL: String
	let size: String?
	let quantity: Int
	let isMenuItem: Bool
	let order_id: UUID

//	struct PollData: Encodable, Sendable {
//		let options: [String]
//		let multiple: Bool
//		let expires_in: Int
//
//		init(options: [String], multiple: Bool, expires_in: Int) {
//			self.options = options
//			self.multiple = multiple
//			self.expires_in = expires_in
//		}
//	}
//
//	struct MediaAttribute: Encodable, Sendable {
//		let id: String
//		let description: String?
//		let thumbnail: String?
//		let focus: String?
//
//		init(id: String, description: String?, thumbnail: String?, focus: String?) {
//			self.id = id
//			self.description = description
//			self.thumbnail = thumbnail
//			self.focus = focus
//		}
//	}

	init(id: UUID? = nil,
		 title: String,
		 price: Double,
		 desc: String,
		 imageURL: String,
		 size: String?,
		 quantity: Int,
		 isMenuItem: Bool,
		 order_id: UUID)
	{
		self.id = id
		self.title = title
		self.price = price
		self.desc = desc
		self.imageURL = imageURL
		self.size = size
		self.quantity = quantity
		self.isMenuItem = isMenuItem
		self.order_id = order_id
	}
}

