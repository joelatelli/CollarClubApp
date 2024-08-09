//
//  CategorizedEmojiContainer.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import Foundation

extension ProductEditor {
  struct CategorizedEmojiContainer: Identifiable, Equatable {
	let id = UUID().uuidString
	let categoryName: String
	var emojis: [Emoji]
  }

}

