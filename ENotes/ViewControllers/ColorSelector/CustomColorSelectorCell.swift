//
//  CustomColorSelectorCell.swift
//  ENotes
//
//  Created by Aleksey on 19/10/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol CustomColorSelectorCellDelegate: class {
	/// Notifies delegate that custom color cell being long pressed.
	func customColorCellDidRecieveLongPress()
}

class CustomColorSelectorCell: ColorSelectorCell {
	/// Delegate of the custom color cell.
	weak var delegate: CustomColorSelectorCellDelegate?
	
	private let selectedColorLayer = CAShapeLayer()

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupSelectedColorLayer()
		setupColorCellViewHueGradient()
		setupGestures()
	}
	
	/// Sets new custom color for current cell.
	/// - Parameter color: New color.
	///
	override func set(_ color: HSBColor) {
		selectedColorLayer.fillColor = color.cgColor
	}
	
	private func setupSelectedColorLayer() {
		selectedColorLayer.path = .circle(in: colorCellView.bounds.scaled(to: 0.7))
		selectedColorLayer.fillColor = UIColor.white.cgColor
		selectedColorLayer.strokeColor = UIColor.white.withAlphaComponent(0.7).cgColor
		selectedColorLayer.lineWidth = 3
		
		addSubayerToColorCell(selectedColorLayer)
	}
	
	private func setupColorCellViewHueGradient() {
		let hueGradientLayer = CAGradientLayer(direction: .fromLeftToRight, colors: .hueComponents)
		addSubayerToColorCell(hueGradientLayer)
	}
	
	private func setupGestures() {
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellBeingLongPressed))
		addGestureRecognizer(longPressGesture)
	}
	
	@objc private func cellBeingLongPressed(gesture: UIGestureRecognizer) {
		if gesture.state == .began {
			delegate?.customColorCellDidRecieveLongPress()
		}
	}
}
