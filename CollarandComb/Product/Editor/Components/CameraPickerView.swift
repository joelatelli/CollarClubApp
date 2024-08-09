//
//  CameraPickerView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import SwiftUI
import UIKit

extension ProductEditor {
  struct CameraPickerView: UIViewControllerRepresentable {
	@Binding var selectedImage: UIImage?
	@Environment(\.dismiss) var dismiss

	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	  let picker: CameraPickerView

	  init(picker: CameraPickerView) {
		self.picker = picker
	  }

	  func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let selectedImage = info[.originalImage] as? UIImage else { return }
		picker.selectedImage = selectedImage
		picker.dismiss()
	  }
	}

	func makeUIViewController(context: Context) -> UIImagePickerController {
	  let imagePicker = UIImagePickerController()
	  #if !os(visionOS)
	  imagePicker.sourceType = .camera
	  #endif
	  imagePicker.delegate = context.coordinator
	  return imagePicker
	}

	func updateUIViewController(_: UIImagePickerController, context _: Context) {}

	func makeCoordinator() -> Coordinator {
	  Coordinator(picker: self)
	}
  }

}

