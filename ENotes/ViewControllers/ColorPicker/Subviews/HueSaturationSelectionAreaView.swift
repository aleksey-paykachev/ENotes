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

class HueSaturationSelectionAreaView: UIView {

	private var color: HSBColor = .white
	private let colorPickerSelectorView = CircleSelectorView(frame: .square(30))
	private let hueGradient = CAGradientLayer()
	private let saturationGradient = CAGradientLayer()
	
	weak var delegate: HueSaturationSelectionAreaViewDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupView()
		setupGestures()
	}
	
	
	// MARK: - Public API
	
	/// Set currently selected color.
	/// Changes selector position and changes gradients according to selected color.

	func set(color: HSBColor) {
		self.color = color
		
		setSelectorPosition(hue: color.hue, saturation: color.saturation)
		updateGradients(with: color.brightness)
	}
	
	// MARK: - Setup
	
	// Two gradient layers are used to draw Hue-Saturation selection area.
	// Hue gradient are drawn from left to right and saturation - from top to bottom above it.
	// Hue gradient contains six step-colors: red, yellow, green, cyan, blue, magenta.
	// More information about HSB-color coding system might be found here:
	// en.wikipedia.org/wiki/HSL_and_HSV
	
	private func setupView() {
		// gradients
		setupGradientFrames()
		
		hueGradient.setDirection(.fromLeftToRight)
		layer.addSublayer(hueGradient)
		
		saturationGradient.setDirection(.fromTopToBottom)
		layer.addSublayer(saturationGradient)
		
		// selector
		colorPickerSelectorView.isOpaque = false
		addSubview(colorPickerSelectorView)
	}
	
	private func setupGradientFrames() {
		hueGradient.frame = bounds.insetBy(dx: 1, dy: 1)
		saturationGradient.frame = bounds.insetBy(dx: 1, dy: 1)
	}
	
	private func setupGestures() {
		let panSelectionAreaGesture = UIPanGestureRecognizer(target: self, action: #selector(selectColorByGesture(gesture:)))
		let tapSelectionAreaGesture = UITapGestureRecognizer(target: self, action: #selector(selectColorByGesture(gesture:)))
		
		addGestureRecognizer(panSelectionAreaGesture)
		addGestureRecognizer(tapSelectionAreaGesture)
	}
	
	// MARK: - Update UI

	private func setSelectorPosition(hue: CGFloat, saturation: CGFloat) {
		let radius = colorPickerSelectorView.radius
		colorPickerSelectorView.frame.origin = CGPoint(
			x: bounds.minX + bounds.width * hue - radius,
			y: bounds.minY + bounds.height * (1.0 - saturation) - radius)
	}
	
	private func updateGradients(with brightness: CGFloat) {
		hueGradient.colors = [UIColor.red.cgColorWithBrightness(brightness),
							  UIColor.yellow.cgColorWithBrightness(brightness),
							  UIColor.green.cgColorWithBrightness(brightness),
							  UIColor.cyan.cgColorWithBrightness(brightness),
							  UIColor.blue.cgColorWithBrightness(brightness),
							  UIColor.magenta.cgColorWithBrightness(brightness),
							  UIColor.red.cgColorWithBrightness(brightness)]
		
		saturationGradient.colors = [UIColor.clear.cgColor,
									 UIColor.white.cgColorWithBrightness(brightness)]
	}
	
	private func moveColorPickerSelectorView(to point: CGPoint) {
		let pointInBounds = point.clamped(in: bounds)
		
		color.hue = 1.0 * pointInBounds.x / frame.width
		color.saturation = 1.0 - 1.0 * pointInBounds.y / frame.height
		
		setSelectorPosition(hue: color.hue, saturation: color.saturation)
		
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
		
		setupGradientFrames()
		setSelectorPosition(hue: color.hue, saturation: color.saturation)
	}
}
