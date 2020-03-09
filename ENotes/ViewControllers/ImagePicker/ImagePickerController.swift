//
//  ImagePickerController.swift
//  ENotes
//
//  Created by Aleksey on 24/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol ImagePickerControllerDelegate: class {
	/// Notify delegate that user did picked some image via image picker.
	func didPick(_ image: UIImage)
}

class ImagePickerController: UIImagePickerController {
	
	weak var imagePickerDelegate: ImagePickerControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

		delegate = self
		allowsEditing = true
		sourceType = .savedPhotosAlbum
    }
}


// MARK: - self delegate

extension ImagePickerController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
	
	// User did pick some image. Dismiss current ViewController, check if selected image could be casted to UIImage, and if so, pass it to delegate.
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		dismiss(animated: true) { [weak self] in
			if let image = info[.editedImage] as? UIImage {
				self?.imagePickerDelegate?.didPick(image)
			}
		}
	}
}
