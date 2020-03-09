//
//  PhotoNoteCollectionViewCell.swift
//  ENotes
//
//  Created by Aleksey on 20/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class PhotoNoteCollectionViewCell: UICollectionViewCell {

	var photoNote: PhotoNote? { didSet { updateUI() } }
	var isEditMode: Bool = false { didSet { setEditMode() } }

	private let contentWrapperView = UIView()
	private let photoImageView = UIImageView()
	private let selectionLayerView = UIView()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	private func updateUI() {
		photoImageView.image = photoNote?.thumbnail
	}
	
	override var isSelected: Bool {
		didSet {
			if isEditMode, isSelected != oldValue {
				isSelected ? select() : deselect()
			}
		}
	}
	
	private func setEditMode() {
		UIView.animate(withDuration: 0.8) {
			let alpha: CGFloat = self.isEditMode ? 0.4 : 0
			self.selectionLayerView.backgroundColor = UIColor.gray.withAlphaComponent(alpha)
		}
	}
	
	private func select() {
		UIView.animate(withDuration: 0.4) {
			self.selectionLayerView.backgroundColor = UIColor.gray.withAlphaComponent(0)
		}
	}

	private func deselect() {
		UIView.animate(withDuration: 0.4) {
			self.selectionLayerView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		photoImageView.image = nil
	}
}


// MARK: - Initial cell setup

extension PhotoNoteCollectionViewCell {
	private func setup() {
		setupContentWrapperView()
		setupPhotoImageView()
		setupSelectionLayerView()
	}
	
	private func setupContentWrapperView() {
		contentView.addSubview(contentWrapperView)
		contentWrapperView.constraint(to: contentView, withEqualInsetsOf: 10)
		
		contentWrapperView.backgroundColor = .white

		contentWrapperView.layer.cornerRadius = 5
		contentWrapperView.layer.shadowColor = UIColor.lightGray.cgColor
		contentWrapperView.layer.shadowOffset = CGSize(width: 0, height: 3)
		contentWrapperView.layer.shadowRadius = 3
		contentWrapperView.layer.shadowOpacity = 0.4
	}
	
	private func setupPhotoImageView() {
		contentWrapperView.addSubview(photoImageView)
		photoImageView.constraint(to: contentWrapperView, withEqualInsetsOf: 15)
		
		photoImageView.contentMode = .scaleAspectFill
		photoImageView.layer.masksToBounds = true

		photoImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
		photoImageView.layer.borderWidth = 1
	}
	
	private func setupSelectionLayerView() {
		contentWrapperView.addSubview(selectionLayerView)
		selectionLayerView.constraint(to: contentWrapperView)
		
		selectionLayerView.backgroundColor = UIColor.gray.withAlphaComponent(0)
	}
}
