//
//  HueSaturationSelectionAreaView.swift
//  ENotes
//
//  Created by Aleksey on 16/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol HueSaturationSelectionAreaViewDelegate: class {
	func hueSaturationDidChanged(hue: CGFloat, saturation: CGFloat)
}

// Two gradient layers are used to draw Hue-Saturation selection area.
// Hue gradient are drawn from left to right and saturation - from top to bottom above it.
// Hue gradient contains six step-colors: red, yellow, green, cyan, blue, magenta.
// More information about HSB-color coding system might be found here:
// en.wikipedia.org/wiki/HSL_and_HSV

class HueSaturationSelectionAreaView: UIView {

	private var color: HSBColor = .white
	private let colorPickerSelectorView = CircleSelectorView(radius: 15)
	private let hueGradient = CAGradientLayer(direction: .fromLeftToRight, colors: [])
	private let saturationGradient = CAGradientLayer(direction: .fromTopToBottom, colors: [])
	
	weak var delegate: HueSaturationSelectionAreaViewDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupGradients()
		setupSelector()
		setupGestures()
	}
	
	
	// MARK: - Public API
	
	/// Set currently selected color.
	/// Changes gradients and selector position according to selected color.
	///
	func set(color: HSBColor) {
		self.color = color

		updateGradients()
		updateSelectorPosition()
	}
	
	// MARK: - Setup
	
	private func setupGradients() {
		layer.addSublayer(hueGradient)
		layer.addSublayer(saturationGradient)

		updateGradientsFrames()
	}
	
	private func setupSelector() {
		colorPickerSelectorView.isOpaque = false
		addSubview(colorPickerSelectorView)
	}
	
	private func updateGradientsFrames() {
		// add little insets to gradient layers to prevent overlapping with the border
		hueGradient.frame = bounds.insetBy(dx: 1, dy: 1)
		saturationGradient.frame = bounds.insetBy(dx: 1, dy: 1)
	}
	
	private func setupGestures() {
		let panSelectionAreaGesture = UIPanGestureRecognizer(target: self, action: #selector(selectColorByGesture))
		let tapSelectionAreaGesture = UITapGestureRecognizer(target: self, action: #selector(selectColorByGesture))
		
		addGestureRecognizer(panSelectionAreaGesture)
		addGestureRecognizer(tapSelectionAreaGesture)
	}
	
	// MARK: - Update UI

	private func updateSelectorPosition() {
		let selectorRadius = colorPickerSelectorView.radius

		colorPickerSelectorView.frame.origin = CGPoint(
			x: bounds.width * color.hue - selectorRadius,
			y: bounds.height * (1.0 - color.saturation) - selectorRadius
		)
	}
	
	private func updateGradients() {
		let hueGradientColors = [UIColor].hueComponents.withBrightness(color.brightness)
		hueGradient.setColors(hueGradientColors)
		
		let saturationGradientColors = [.clear, UIColor.white.withBrightness(color.brightness)]
		saturationGradient.setColors(saturationGradientColors)
	}
	
	private func moveColorPickerSelectorView(to point: CGPoint) {
		let pointInBounds = point.clamped(in: bounds)
		
		color.hue = pointInBounds.x / bounds.width
		color.saturation = 1.0 - pointInBounds.y / bounds.height
		updateSelectorPosition()

		delegate?.hueSaturationDidChanged(hue: color.hue, saturation: color.saturation)
	}
	
	// MARK: - Gestures
	
	@objc private func selectColorByGesture(gesture: UIGestureRecognizer) {
		switch gesture.state {
		case .began, .changed, .ended:
			let selectedPoint = gesture.location(in: self)
			moveColorPickerSelectorView(to: selectedPoint)
		default:
			break
		}
	}
	
	// MARK: - View size changes and rotation handling
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		updateGradientsFrames()
		updateSelectorPosition()
	}
}
