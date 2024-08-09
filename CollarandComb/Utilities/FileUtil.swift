//
//  FileUtil.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation

enum FileUtil {
	static var documentDirectory: URL {
		url(for: .documentDirectory)!
	}
	static var cachesDirectory: URL {
		url(for: .cachesDirectory)!
	}
	static var logsDirectoryURL: URL {
		documentDirectory.appendingPathComponent(Defaults.FilePath.logs)
	}
	static var temporaryDirectory: URL {
		.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
	}

	static func url(for searchPathDirectory: FileManager.SearchPathDirectory) -> URL? {
		try? FileManager.default.url(for: searchPathDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
	}
}

