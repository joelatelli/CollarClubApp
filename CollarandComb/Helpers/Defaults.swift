//
//  Defaults.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation

enum Defaults {
	enum FilePath {
		static let logs = "logs"
		static let appLog = "CollarAndCombApp.log"
	}

	enum Security {
		// set `minBlurRadius` to 0.1 because setting it lower value causes UI bug
		static let minBlurRadius = 0.1
		static let maxBlurRadius = 20.1
		static let blurRadiusStep = 1.0
	}

	enum Search {
		static let maxSearchHistorySize = 10
	}

	enum Storage {
		static let settingsConfig = "settingsConfig"
	}

	enum Links {
		static let bmcLink = URL(string: "https://www.buymeacoffee.com/oolxg")!
		static let githubAvatarLink = URL(string: "https://github.com/oolxg.png")!
		static let githubUserLink = URL(string: "https://github.com/oolxg")!
		static let githubProjectLink = URL(string: "https://github.com/oolxg/Hanami")!
	}
}


