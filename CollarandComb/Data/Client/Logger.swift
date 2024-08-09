//
//  Logger.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/28/23.
//

import Foundation
import ComposableArchitecture
import SwiftyBeaver

struct Logger {
	private let logger: SwiftyBeaver.Type = {
		let log = SwiftyBeaver.self
		let file = FileDestination()
		let console = ConsoleDestination()
		let format = "$Dyyyy.MM.dd HH:mm:ss.SSS$d $C$L$c - $M $X"

		file.format = format
		file.logFileAmount = 10
		file.calendar = Calendar(identifier: .gregorian)
		file.logFileURL = FileUtil.logsDirectoryURL.appendingPathComponent(Defaults.FilePath.appLog)

		console.format = format
		console.calendar = Calendar(identifier: .gregorian)
		console.asynchronously = false
		console.levelColor.verbose = "😪"
		console.levelColor.warning = "⚠️"
		console.levelColor.error = "‼️"
		console.levelColor.debug = "🐛"
		console.levelColor.info = "📖"

		log.addDestination(file)
		#if DEBUG
		log.addDestination(console)
		#endif

		return log
	}()

	func error(_ message: Any, context: Any? = nil) {
		logger.error(message, context: context)
	}

	func warning(_ message: Any, context: Any? = nil) {
		logger.warning(message, context: context)
	}

	func info(_ message: Any, context: Any? = nil) {
		logger.info(message, context: context)
	}

	func debug(_ message: Any, context: Any? = nil) {
		logger.debug(message, context: context)
	}

	func verbose(_ message: Any, context: Any? = nil) {
		logger.verbose(message, context: context)
	}
}

extension Logger: DependencyKey {
	static let liveValue = Logger()
}

extension DependencyValues {
	var logger: Logger {
		get { self[Logger.self] }
		set { self[Logger.self] = newValue }
	}
}

