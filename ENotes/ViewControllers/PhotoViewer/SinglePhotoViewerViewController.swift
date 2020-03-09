//
//  SinglePhotoViewerViewController.swift
//  ENotes
//
//  Created by Aleksey on 18/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Show single photo note placed on a scroll view, so an image could be zoomed in and out.
/// Rotation and chages the size of the main view causes photo image to be placed at the
/// center and zoomed appropriately to fill the entire screen.
class SinglePhotoViewerViewController: UIViewController {

	let photoNote: PhotoNote

	private let scrollView = UIScrollView()
	private var photoImageView: UIImageView!

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(photoNote: PhotoNote) {
		self.photoNote = photoNote
		super.init(nibName: nil, bundle: nil)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupScrollView()
		setupPhotoImageView()
		zoomAndCenterImage()
    }
	
	private func setupScrollView() {
		view.addSubview(scrollView)
		scrollView.constraint(to: view)
		
		scrollView.maximumZoomScale = 3
		
		scrollView.backgroundColor = .black
		scrollView.delegate = self
	}
	
	private func setupPhotoImageView() {
		photoImageView = UIImageView(image: photoNote.image)
		scrollView.addSubview(photoImageView)
		
		photoImageView.frame.size = photoNote.image?.size ?? .zero
	}
	
	private func zoomAndCenterImage() {
		let scrollViewSize = scrollView.bounds.size
		let imageSize = photoImageView.bounds.size

		let widthZoomRatio = scrollViewSize.width / imageSize.width
		let heightZoomRatio = scrollViewSize.height / imageSize.height
		let zoomRatio = min(widthZoomRatio, heightZoomRatio)
		
		scrollView.minimumZoomScale = zoomRatio
		scrollView.zoomScale = zoomRatio
		
		let insetX = (scrollViewSize.width - photoImageView.frame.width) / 2
		let insetY = (scrollViewSize.height - photoImageView.frame.height) / 2
		scrollView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		zoomAndCenterImage()
	}
}


// MARK: - scrollView delegate

extension SinglePhotoViewerViewController: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return photoImageView
	}
}
