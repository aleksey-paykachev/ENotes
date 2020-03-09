//
//  ColorSelectorCollectionViewCell.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Color selector cell for standard color
class ColorSelectorCollectionViewCell: UICollectionViewCell {
	
	private var colorCellView: UIView!
	private let markSignView = MarkSignView()
	
	/// Bounds of color cell.
	var cellBounds: CGRect {
		#warning("...")
		
		return colorCellView?.bounds ?? .zero
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupColorCellView()
		setupMarkSignView()
	}
	
	/// Sets new color for current cell.
	///
	/// - Parameter color: New color.
	///
	func set(_ color: UIColor) {
		colorCellView.backgroundColor = color
	}
	
	/// Adds new layer on color cell view.
	///
	/// - Parameters:
	///   - layer: Added layer.
	///   - level: New layer level index. If no level index were provided, insert on top.
	///
	func addLayer(_ layer: CALayer, at level: UInt32 = 0) {
		#warning("...")
		
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
		colorCellView = UIView(frame: bounds.scaled(to: 0.9))
		addSubview(colorCellView)
		
		colorCellView.layer.cornerRadius = colorCellView.frame.width / 2 //circle
		colorCellView.layer.masksToBounds = true
		
		colorCellView.layer.borderWidth = 1.0
		colorCellView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
		
		setColorCellViewGradient()
	}
	
	private func setupMarkSignView() {
		// add and constraint mark sign view at the upper right corner
		
		addSubview(markSignView)
		markSignView.translatesAutoresizingMaskIntoConstraints = false
		markSignView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		markSignView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		markSignView.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
		markSignView.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	private func setColorCellViewGradient() {
		let gradient = CAGradientLayer()
		gradient.colors = [
			UIColor.darkGray.withAlphaComponent(0.3).cgColor,
			UIColor.clear.cgColor]
		gradient.setDirection(.fromBottomToTop)
		addLayer(gradient)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()

		colorCellView.backgroundColor = nil
	}
}
