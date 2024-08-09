//
//  ResponseData.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/25/23.
//

import Foundation

struct ResponseData<ResponseData>: Decodable, Equatable where ResponseData: Equatable & Decodable {
	let result: String
	let data: ResponseData
	let limit: Int?
	let total: Int?
}
