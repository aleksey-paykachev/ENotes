//
//  CustomColorSelectorCell.swift
//  ENotes
//
//  Created by Aleksey on 19/10/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol CustomColorSelectorCellDelegate: class {
	/// Notifies delegate that custom color cell selector did ask for color picker.
	func colorSelectorCellDidAskForColorPicker()
}

class CustomColorSelectorCell: ColorSelectorCell {
	weak var delegate: CustomColorSelectorCellDelegate?
	
	private let selectedColorLayer = CAShapeLayer()

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setSelectedColorLayer()
		setColorCellViewHueGradient()
		
		// add long press gesture
		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(cellBeingLongPressed(gesture:)))
		addGestureRecognizer(gesture)
	}
	
	override func set(_ color: HSBColor) {
//		let color = color ?? .white
		print("Set custom color: \(color)")
		selectedColorLayer.fillColor = color.cgColor
	}
	
	private func setSelectedColorLayer() {
		selectedColorLayer.path = CGPath(ellipseIn: cellBounds.scaled(to: 0.7), transform: nil)
		selectedColorLayer.fillColor = UIColor.white.cgColor
		selectedColorLayer.strokeColor = UIColor.gray.withAlphaComponent(0.3).cgColor
		addLayer(selectedColorLayer)
	}
	
	private func setColorCellViewHueGradient() {
//		private var hueGradient: CAGradientLayer!
		let hueGradient = CAGradientLayer()
		hueGradient.colors = [UIColor.red.cgColor,
							  UIColor.yellow.cgColor,
							  UIColor.green.cgColor,
							  UIColor.cyan.cgColor,
							  UIColor.blue.cgColor,
							  UIColor.magenta.cgColor,
							  UIColor.red.cgColor]
		hueGradient.setDirection(.fromLeftToRight)
		addLayer(hueGradient, at: 0)
	}
	
	@objc private func cellBeingLongPressed(gesture: UIGestureRecognizer) {
		if gesture.state == .began {
			delegate?.colorSelectorCellDidAskForColorPicker()
		}
	}
}
