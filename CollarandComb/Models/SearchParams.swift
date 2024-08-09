//
//  SearchParams.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import Foundation
import typealias IdentifiedCollections.IdentifiedArrayOf

struct SearchParams: Equatable {
	let searchQuery: String
	let resultsCount: Int

//	let sortOption: FiltersFeature.QuerySortOption
//	let sortOptionOrder: FiltersFeature.QuerySortOption.Order

}

extension SearchParams: Codable { }
