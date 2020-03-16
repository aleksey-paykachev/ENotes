//
//  ImagePickerController.swift
//  ENotes
//
//  Created by Aleksey on 24/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol ImagePickerControllerDelegate: class {
	/// Notify delegate that user did pick an image via image picker.
	func didPick(_ image: UIImage)
}

class ImagePickerController: UIImagePickerController {
	
	weak var imagePickerDelegate: ImagePickerControllerDelegate?

	convenience init(source: SourceType, delegate: ImagePickerControllerDelegate) {
		self.init()
		
		sourceType = source
		imagePickerDelegate = delegate
		setup()
	}
	
	private func setup() {
		modalPresentationStyle = .fullScreen
		allowsEditing = true
		delegate = self
	}
}


// MARK: - self delegate

extension ImagePickerController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		// User did pick an image. Dismiss current ViewController, check if selected image could be casted to UIImage, and if so, pass it to delegate.

		dismiss(animated: true) {
			// strong self captured intentionally to send delegate's didPick() method
			if let image = info[.editedImage] as? UIImage {
				self.imagePickerDelegate?.didPick(image)
			}
		}
	}
}
