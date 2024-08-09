//
//  MediaContainer.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

extension ProductEditor {
	struct MediaContainer: Identifiable {
		let id: String
		let image: UIImage?
		let movieTransferable: MovieFileTranseferable?
		let gifTransferable: GifFileTranseferable?
		let mediaAttachment: MediaAttachment?
		let error: Error?
	}
}

