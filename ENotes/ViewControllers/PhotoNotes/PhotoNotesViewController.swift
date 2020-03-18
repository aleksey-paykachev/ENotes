//
//  PhotoNotesViewController.swift
//  ENotes
//
//  Created by Aleksey on 19/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class PhotoNotesViewController: UICollectionViewController {
	
	private let notebook: Notebook<PhotoNote>
	
	private let backgroundColor = UIColor(white: 0.95, alpha: 1)
	private let minimumPhotoNoteImageSideSize: CGFloat = 170
	private let minimumPhotosPerRow: CGFloat = 2
	
	private let flowLayout = UICollectionViewFlowLayout()
	private var addBarButtonItem: UIBarButtonItem!
	private var deleteBarButtonItem: UIBarButtonItem!
	private let selectedPhotosCounterLabel = UILabel()
	
	private var selectedIndexPaths: [IndexPath] {
		collectionView.indexPathsForSelectedItems ?? []
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(notebook: Notebook<PhotoNote>) {
		self.notebook = notebook
		super.init(collectionViewLayout: flowLayout)

		setupCommon()
		setupNavigationItem()
		setupToolbar()
		setupFlowLayout()
		setupCollectionView()
	}

	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		// animate changing of editing state
		UIView.animate(withDuration: 0.6) {
			self.collectionView.backgroundColor = self.isEditing ? .gray : self.backgroundColor
		}
		
		// update editing state for all visible cells
		for case let cell as PhotoNoteCell in collectionView.visibleCells {
			cell.isEditMode = isEditing
		}

		// deselect all selected cells
		selectedIndexPaths.forEach { collectionView.deselectItem(at: $0, animated: false) }
		
		// update UI elements
		navigationController?.setToolbarHidden(!isEditing, animated: true)
		addBarButtonItem.isEnabled = !isEditing
		updateToolbar()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		collectionViewLayout.invalidateLayout()
	}
	
	// MARK: - Setup
	
	private func setupCommon() {
		title = LocalizedString.PhotoNotes.title
		tabBarItem.image = UIImage(named: "tabbar-icon-photonotes")
	}
	
	private func setupNavigationItem() {
		addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoNoteButtonDidPressed))
		
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.rightBarButtonItem = addBarButtonItem
	}
	
	private func setupToolbar() {
		// counter label
		selectedPhotosCounterLabel.textColor = .darkGray
		let selectedPhotosCounterLabelItem = UIBarButtonItem(customView: selectedPhotosCounterLabel)

		// spacer
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

		// delete button
		deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePhotosButtonWasTapped))
		deleteBarButtonItem.tintColor = .red
		
		toolbarItems = [selectedPhotosCounterLabelItem, spacer, deleteBarButtonItem]
	}
	
	private func setupFlowLayout() {
		flowLayout.minimumInteritemSpacing = 0
		flowLayout.minimumLineSpacing = 0
	}
	
	private func setupCollectionView() {
		collectionView.backgroundColor = backgroundColor
		collectionView.contentInsetAdjustmentBehavior = .always
		collectionView.allowsMultipleSelection = true
		collectionView.registerCell(PhotoNoteCell.self)
	}
	
	// MARK: - Private methods
	
	@objc private func deletePhotosButtonWasTapped() {
		guard isEditing, selectedIndexPaths.count > 0 else { return }

		selectedIndexPaths.items.sorted(by: >).forEach { notebook.remove(at: $0) }
		collectionView.deleteItems(at: selectedIndexPaths)
		
		updateToolbar()
	}
	
	private func updateToolbar() {
		selectedPhotosCounterLabel.text = "\(LocalizedString.PhotoNotes.selectedPhotosCounter): \(selectedIndexPaths.count)"
		deleteBarButtonItem.isEnabled = selectedIndexPaths.isNotEmpty
	}
	
	@objc private func addPhotoNoteButtonDidPressed() {
		// check if device have a camera, and if not, show photo library image picker
		if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
			let libraryPicker = ImagePickerController(source: .photoLibrary, delegate: self)
			present(libraryPicker, animated: true)
			return
		}
		
		// if device do have a camera, show photo note image source selector: library or camera
		let imageSourceSelectorAlertController = UIAlertController(title: LocalizedString.ImageSourceSelector.title, message: nil, preferredStyle: .actionSheet)

		let addImageFromCameraAction = UIAlertAction(title: LocalizedString.ImageSourceSelector.cameraButton, style: .default) { _ in

			let cameraPicker = ImagePickerController(source: .camera, delegate: self)
			self.present(cameraPicker, animated: true)
		}
		let addImageFromPhotoLibraryAction = UIAlertAction(title: LocalizedString.ImageSourceSelector.photoLibraryButton, style: .default) { _ in

			let libraryPicker = ImagePickerController(source: .photoLibrary, delegate: self)
			self.present(libraryPicker, animated: true)
		}
		let cancelAction = UIAlertAction(title: LocalizedString.ImageSourceSelector.cancelButton, style: .cancel)

		imageSourceSelectorAlertController.addAction(addImageFromCameraAction)
		imageSourceSelectorAlertController.addAction(addImageFromPhotoLibraryAction)
		imageSourceSelectorAlertController.addAction(cancelAction)

		present(imageSourceSelectorAlertController, animated: true)
	}
	
	private func addItem(image: UIImage) {
		// Add new photo note and scroll to its position
		guard let photoNote = PhotoNote(image: image) else { return }

		notebook.add(photoNote)
		let newItemIndexPath = IndexPath(item: notebook.count - 1, section: 0)
		collectionView.insertItems(at: [newItemIndexPath])
		collectionView.scrollToItem(at: newItemIndexPath, at: .bottom, animated: true)
	}
}


// MARK: - self dataSource

extension PhotoNotesViewController {
	
	// Data source
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		notebook.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueCell(PhotoNoteCell.self, for: indexPath)
		cell.photoNote = notebook.get(by: indexPath.item)
		cell.isEditMode = isEditing
		
		return cell
	}
	
	// Reordering
	
	override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		// allow reordering only in editing mode
		isEditing
	}
	
	override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		notebook.moveNoteByIndex(from: sourceIndexPath.item, to: destinationIndexPath.item)
	}
}


// MARK: - self delegate

extension PhotoNotesViewController {
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// In editing mode user can select multiple photo notes. Bottom toolbar are used to show currently avaliable actions for selected notes. In standard (non-editing) mode selection of a note causes showing of a photo viewer.

		if isEditing {
			updateToolbar()

		} else {
			let note = notebook.get(by: indexPath.item)
			let photoNotesViewer = PhotoNotesViewerViewController(photoNotebook: notebook, photoNote: note)
			navigationController?.pushViewController(photoNotesViewer, animated: true)
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if isEditing {
			updateToolbar()
		}
	}
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoNotesViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// Calculate appropriate number of items per column and its sizes respecting current collection view width and default minimum photo note size
		
		let collectionViewWidth = collectionView.bounds.width - collectionView.safeAreaInsets.left - collectionView.safeAreaInsets.right
		var itemsPerRow = floor(collectionViewWidth / minimumPhotoNoteImageSideSize)
		itemsPerRow = max(minimumPhotosPerRow, itemsPerRow)
		let itemSize = floor(collectionViewWidth / itemsPerRow)
		
		return .square(itemSize)
	}
}


// MARK: - ImagePickerControllerDelegate

extension PhotoNotesViewController: ImagePickerControllerDelegate {
	func didPick(_ image: UIImage) {
		addItem(image: image)
	}
}
