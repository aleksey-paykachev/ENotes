//
//  ColorSelectorCell.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Color selector cell for standard color
class ColorSelectorCell: UICollectionViewCell {
	
	lazy var colorCellView = UIView(frame: bounds.scaled(to: 0.9))
	private let markSignView = MarkSignView()
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupColorCellView()
		setupMarkSignView()
	}
	
	/// Sets new color for current cell.
	/// - Parameter color: New color.
	///
	func set(_ color: HSBColor) {
		colorCellView.backgroundColor = color.uiColor
	}
	
	/// Adds new sublayer to color cell view layer.
	///
	/// - Parameters:
	///   - layer: Added layer.
	///   - level: New layer level index. If no level index were provided, insert on bottom.
	///
	func addSubayerToColorCell(_ layer: CALayer, at level: UInt32 = 0) {
		layer.frame = colorCellView.bounds
		colorCellView.layer.insertSublayer(layer, at: level)
	}
	
	override var isSelected: Bool {
		didSet {
			if isSelected != oldValue {
				isSelected ? markSignView.show() : markSignView.hide()
			}
		}
	}
	
	private func setupColorCellView() {
		contentView.addSubview(colorCellView)
		
		colorCellView.layer.setRadius(colorCellView.frame.width / 2) //circle
		colorCellView.layer.setBorder(width: 1, color: .lightGray, alpha: 0.8)
		colorCellView.layer.setGradient(direction: .fromBottomToTop,
										colors: [UIColor.darkGray.withAlphaComponent(0.3), .clear])
	}
	
	private func setupMarkSignView() {
		// add mark sign view at the upper right corner
		contentView.addSubview(markSignView)
		
		let sideSize = contentView.bounds.width / 2
		markSignView.frame = CGRect(origin: CGPoint(x: sideSize, y: 0), size: .square(sideSize))
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()

		colorCellView.backgroundColor = nil
	}
}
