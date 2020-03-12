//
//  PhotoNotesCollectionViewController.swift
//  ENotes
//
//  Created by Aleksey on 19/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

// Котозаметки - это фотозаметки с котами. Подразумевается, что любой, кто запустит данную программу, первым делом удалит имеющиеся фотозаметки с собаками

class PhotoNotesCollectionViewController: UICollectionViewController {
	
	private let notebook: Notebook<PhotoNote>
	
	lazy private var addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showImagePicker))
	lazy private var deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePhotosButtonWasTapped))
	lazy private var imagePickerController: ImagePickerController = {
		let imagePickerController = ImagePickerController()
		imagePickerController.imagePickerDelegate = self
		return imagePickerController
	}()
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(notebook: Notebook<PhotoNote>) {
		self.notebook = notebook
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
		
		title = NSLocalizedString("Photo Notes", comment: "Photo notes list title. Shown both in navigation bar at the top and in the tab bar at the bottom.")
		tabBarItem.image = UIImage(named: "tabbar-icon-photonotes")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Navigation bar and toolbar
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.rightBarButtonItem = addBarButtonItem
		toolbarItems = [deleteBarButtonItem]

		// Collection view
		collectionView.backgroundColor = Constants.photoNotesListBackgroundColor
		collectionView.contentInsetAdjustmentBehavior = .always
		collectionView.allowsMultipleSelection = false
		collectionView.register(PhotoNoteCollectionViewCell.self, forCellWithReuseIdentifier: PhotoNoteCollectionViewCell.reuseIdentifier)
    }

	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		UIView.animate(withDuration: Constants.switchEditingModeAnimationDuration) {
			self.collectionView.backgroundColor = self.isEditing ? .gray : Constants.photoNotesListBackgroundColor
		}
		
		navigationController?.setToolbarHidden(!isEditing, animated: true)
		addBarButtonItem.isEnabled = !isEditing
		deleteBarButtonItem.isEnabled = false
		
		collectionView.allowsMultipleSelection = isEditing
		collectionView.visibleCells.forEach {
			let cell = $0 as! PhotoNoteCollectionViewCell
			cell.isEditMode = isEditing
		}

		if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
			selectedIndexPaths.forEach { collectionView.deselectItem(at: $0, animated: false) }
		}		
	}
	
	private func updateToolbar() {
		let selectedCellsCount = collectionView.indexPathsForSelectedItems?.count ?? 0
		deleteBarButtonItem.isEnabled = selectedCellsCount > 0
	}
	
	@objc private func deletePhotosButtonWasTapped() {
		if isEditing, let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
			selectedIndexPaths.map { $0.item }.sorted().reversed().forEach { notebook.remove(at: $0) }
			collectionView.deleteItems(at: selectedIndexPaths)
			
			updateToolbar()
		}
	}
	
	@objc private func showImagePicker() {
		navigationController?.present(imagePickerController, animated: true)
	}
	
	private func addItem(image: UIImage) {
		// Add new photo note and scroll to its position
		guard let photoNote = PhotoNote(image: image) else { return }

		notebook.add(photoNote)
		let newItemIndexPath = IndexPath(item: self.notebook.count - 1, section: 0)
		collectionView.insertItems(at: [newItemIndexPath])
		collectionView.scrollToItem(at: newItemIndexPath, at: .bottom, animated: true)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		collectionViewLayout.invalidateLayout()
	}
	
	private struct Constants {
		static let photoNotesListBackgroundColor = UIColor(white: 0.95, alpha: 1)
		static let switchEditingModeAnimationDuration: TimeInterval = 0.8
		static let minimumPhotoNoteImageSideSize: CGFloat = 200
	}
}


// MARK: - self dataSource

extension PhotoNotesCollectionViewController {
	
	// Data source
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return notebook.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoNoteCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoNoteCollectionViewCell
		cell.photoNote = notebook.get(by: indexPath.item)
		cell.isEditMode = isEditing
		
		return cell
	}
	
	// Reordering
	
	override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return isEditing
	}
	
	override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		notebook.moveNoteByIndex(from: sourceIndexPath.item, to: destinationIndexPath.item)
	}
}


// MARK: - self delegate

extension PhotoNotesCollectionViewController {
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// In editing mode user can select multiple photo notes. Bottom toolbar are used to show currently avaliable actions for selected notes.
		// In standard (non-editing) mode selection of a photo note creates and shows a new instance of a photo viewer.

		if isEditing {
			updateToolbar()
		} else {
			let note = notebook.get(by: indexPath.item)
			
			let photoViewer = PhotoViewerPageViewController(photoNotebook: notebook, photoNote: note)
			navigationController?.pushViewController(photoViewer, animated: true)
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if isEditing {
			updateToolbar()
		}
	}
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoNotesCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// Calculate appropriate number of items per column and its sizes respecting current collection view width and default minimum photo note size
		
		let collectionViewWidth = collectionView.frame.width - collectionView.safeAreaInsets.left - collectionView.safeAreaInsets.right
		let itemsPerColumn = floor(collectionViewWidth / Constants.minimumPhotoNoteImageSideSize)
		let itemSize = floor(collectionViewWidth / itemsPerColumn)
		
		return .square(itemSize)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

		return 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		
		return 0
	}
}


// MARK: - ImagePickerControllerDelegate

extension PhotoNotesCollectionViewController: ImagePickerControllerDelegate {
	func didPick(_ image: UIImage) {
		addItem(image: image)
	}
}
