//
//  PhotoNotesViewerViewController.swift
//  ENotes
//
//  Created by Aleksey on 18/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Show multiple photo notes using left-right pagination. Only one note is shown at the time via single photo viewer.
class PhotoNotesViewerViewController: UIPageViewController {
	
	private let photoNotebook: Notebook<PhotoNote>
	private let photoNote: PhotoNote
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Create and return an instance of photo notes viewer.
	///
	/// - Parameters:
	///   - photoNotebook: Reference to notebook instance containing photo notes to show.
	///   - photoNote: Currently selected photo note.
	///
	init(photoNotebook: Notebook<PhotoNote>, photoNote: PhotoNote) {
		self.photoNotebook = photoNotebook
		self.photoNote = photoNote

		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
		
		let singlePhotoViewerVC = SinglePhotoViewerViewController(photoNote: photoNote)
		setViewControllers([singlePhotoViewerVC], direction: .forward, animated: true)
		dataSource = self
		
		setupGestures()
	}
	
	private func setupGestures() {
		let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(photoDidSwipedDown))
		swipeDownGesture.direction = .down
		view.addGestureRecognizer(swipeDownGesture)
	}
	
	@objc private func photoDidSwipedDown(gesture: UIGestureRecognizer) {
		// hide photo viewer on swipe down gesture
		if gesture.state == .ended {
			navigationController?.popViewController(animated: true)
		}
	}

	/// Gets an index of a photo note shown by given view controller.
	///
	/// - Parameter viewController: View Controller used to show a single photo note.
	/// - Returns: Index of a photo note in current notebook or nil if there is no such note.
	///
	private func getIndex(of viewController: UIViewController) -> Int? {
		if let photoNote = (viewController as? SinglePhotoViewerViewController)?.photoNote, let index = photoNotebook.getIndex(by: photoNote) {
			return index
		}
		
		return nil
	}
}


// MARK: - self dataSource

extension PhotoNotesViewerViewController: UIPageViewControllerDataSource {

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		if let index = getIndex(of: viewController), index - 1 >= 0 {
			return SinglePhotoViewerViewController(photoNote: photoNotebook.get(by: index - 1))
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		if let index = getIndex(of: viewController), index + 1 < photoNotebook.count {
			return SinglePhotoViewerViewController(photoNote: photoNotebook.get(by: index + 1))
		}
		
		return nil
	}
}
