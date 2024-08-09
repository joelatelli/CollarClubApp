//
//  Arrays.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/25/23.
//

import UIKit
import typealias IdentifiedCollections.IdentifiedArrayOf
import Foundation

// swiftlint:disable identifier_name
extension Array {
	func mapIndex<T>(_ closure: (Int, Element) -> T) -> [T] {
		var mapped: [T] = []
		for (index, item) in enumerated() {
			mapped.append(closure(index, item))
		}
		return mapped
	}

	func rightShift() -> Array {
		var new = self
		guard let lastElement = last else { return [] }
		for index in indices where index > 0 {
			new[index] = self[index - 1]
		}
		new[0] = lastElement
		return new
	}

	func leftShift() -> Array {
		var new = self
		guard let firstElement = first else { return [] }
		for index in indices where index - 1 >= 0 {
			let toIndex = index - 1
			new[toIndex] = self[index]
		}

		new[count - 1] = firstElement
		return new
	}

	func get(index: Int) -> Element? {
		guard
			index >= 0,
			index <= (count - 1) else { return nil }
		return self[index]
	}
}

extension CGFloat {
	static func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
		let diff = to - from
		guard progress != 0 else { return from }
		return (diff * progress) + from
	}

	func interpolate(to: CGFloat, progress: CGFloat) -> CGFloat {
		return CGFloat.interpolate(from: self, to: to, progress: progress)
	}
}

extension Double {
	func interpolate(to: Double, progress: Double) -> Double {
		let diff = to - self
		guard progress != 0 else { return self }
		return (diff * progress) + self
	}
}

extension CGPoint {
	func interpolate(to: CGPoint, progress: CGFloat) -> CGPoint {
		return CGPoint(x: x.interpolate(to: to.x, progress: progress),
					   y: y.interpolate(to: to.y, progress: progress))
	}
}

extension CGSize {
	func interpolate(to: CGSize, progress: CGFloat) -> CGSize {
		return CGSize(width: width.interpolate(to: to.width, progress: progress),
					  height: height.interpolate(to: to.height, progress: progress))
	}
}


extension Array {
	func chunked(into size: Int) -> [[Element]] {
		stride(from: 0, to: count, by: size).map {
			Array(self[$0..<Swift.min($0 + size, count)])
		}
	}
}

extension Array where Element: Hashable {
	func removeDuplicates() -> [Element] {
		var set = Set<Element>()
		return filter { set.insert($0).inserted }
	}
}


extension Array where Element == Int {
	func getAllSubsequences() -> [[Element]] {
		var result: [[Int]] = []
		var subsequence: [Int] = []

		let array = self.sorted()

		for element in array {
			if subsequence.isEmpty {
				subsequence.append(element)
			} else {
				if subsequence.last! + 1 == element {
					subsequence.append(element)
				} else {
					result.append(subsequence)
					subsequence = [element]
				}
			}

			if subsequence.last! == array.last! {
				result.append(subsequence)
			}
		}

		return result
	}
}

extension Array where Element: Identifiable {
	var asIdentifiedArray: IdentifiedArrayOf<Element> {
		IdentifiedArrayOf(uniqueElements: self)
	}
}
