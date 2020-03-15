//
//  PhotoNoteCell.swift
//  ENotes
//
//  Created by Aleksey on 20/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class PhotoNoteCell: UICollectionViewCell {

	private let contentWrapperView = UIView()
	private let photoImageView = UIImageView()
	private let selectionLayerView = UIView()
	
	private let selectedStateColor = UIColor.gray.withAlphaComponent(0)
	private let deselectedStateColor = UIColor.gray.withAlphaComponent(0.4)

	var photoNote: PhotoNote? { didSet { updateUI() } }
	var isEditMode: Bool = false { didSet { setEditMode() } }

	override var isSelected: Bool {
		didSet {
			if isSelected != oldValue, isEditMode {
				isSelected ? select() : deselect()
			}
		}
	}
	
	// MARK: - Init
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupContentWrapperView()
		setupPhotoImageView()
		setupSelectionLayerView()
	}
	
	// MARK: - Setup
	
	private func setupContentWrapperView() {
		contentView.addSubview(contentWrapperView)
		contentWrapperView.constrain(to: contentView, withAllEdgesInsets: 10)
		
		contentWrapperView.backgroundColor = .white
		contentWrapperView.layer.setRadius(5, maskToBounds: false)
		contentWrapperView.layer.setShadow(radius: 3, color: .lightGray, offsetY: 3, alpha: 0.4)
	}
	
	private func setupPhotoImageView() {
		contentWrapperView.addSubview(photoImageView)
		photoImageView.constrain(to: contentWrapperView, withAllEdgesInsets: 15)

		photoImageView.contentMode = .scaleAspectFill
		photoImageView.layer.masksToBounds = true
		photoImageView.layer.setBorder(width: 1, color: .lightGray, alpha: 0.5)
	}
	
	private func setupSelectionLayerView() {
		contentWrapperView.addSubview(selectionLayerView)
		selectionLayerView.constraint(to: contentWrapperView)
	}
	
	// MARK: - Private methods
	
	private func updateUI() {
		photoImageView.image = photoNote?.thumbnail
	}
	
	private func setEditMode() {
		let selectionLayerStateColor = isEditMode ? deselectedStateColor : selectedStateColor

		UIView.animate(withDuration: 0.6) {
			self.selectionLayerView.backgroundColor = selectionLayerStateColor
		}
	}
	
	private func select() {
		UIView.animate(withDuration: 0.4) {
			self.selectionLayerView.backgroundColor = self.selectedStateColor
		}
	}

	private func deselect() {
		UIView.animate(withDuration: 0.4) {
			self.selectionLayerView.backgroundColor = self.deselectedStateColor
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		photoImageView.image = nil
	}
}
