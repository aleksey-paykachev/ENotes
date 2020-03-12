//
//  BrightnessSliderView.swift
//  ENotes
//
//  Created by Aleksey on 16/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol BrightessSliderViewDelegate: class {
	func brightnessDidChanged(to brightness: CGFloat)
}

class BrightnessSliderView: UIView {

	weak var delegate: BrightessSliderViewDelegate?

	private var color = HSBColor.white
	private let brightnessGradient = CAGradientLayer()
	private let sliderSelectorView = RectangularSelectorView(frame: .rectangle(width: 20, height: 60))
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupView()
		setupGestures()
	}
	
	// MARK: - Public API
	
	/// Set currently selected color.
	/// Moves slider and changes gradient according to selected color.
	
	func set(color: HSBColor) {
		self.color = color
		
		setSelectorPosition(brightness: color.brightness)
		updateGradient(with: color)
	}
	
	// MARK: - Setup
	
	private func setupView() {
		// gradient
		setupGradientFrame()
		brightnessGradient.setDirection(.fromLeftToRight)
		layer.addSublayer(brightnessGradient)
		
		// selector
		sliderSelectorView.isOpaque = false
		addSubview(sliderSelectorView)
	}
	
	private func setupGradientFrame() {
		brightnessGradient.frame = bounds.insetBy(dx: 1, dy: 1)
	}
	
	private func setupGestures() {
		let panBrightnessSliderGesture = UIPanGestureRecognizer(target: self, action: #selector(selectBrightnessByGesture(gesture:)))
		let tapBrightnessSliderGesture = UITapGestureRecognizer(target: self, action: #selector(selectBrightnessByGesture(gesture:)))
		
		addGestureRecognizer(panBrightnessSliderGesture)
		addGestureRecognizer(tapBrightnessSliderGesture)
	}
	
	// MARK: - Update UI
	
	private func setSelectorPosition(brightness: CGFloat) {
		sliderSelectorView.frame.origin.x = bounds.minX + bounds.width * brightness - sliderSelectorView.bounds.width / 2
	}
	
	private func updateGradient(with color: HSBColor) {
		brightnessGradient.colors = [UIColor.black.cgColor, color.cgColor]
	}

	private func moveBrightnessSliderValueSelectorView(to point: CGPoint) {
		let positionInBounds = point.clamped(in: bounds).x
		
		color.brightness = 1.0 * positionInBounds / frame.width
		setSelectorPosition(brightness: color.brightness)
		
		delegate?.brightnessDidChanged(to: color.brightness)
	}
	
	// MARK: Gestures
	
	@objc private func selectBrightnessByGesture(gesture: UIGestureRecognizer) {
		switch gesture.state {
		case .began, .changed, .ended:
			let selectedPoint = gesture.location(in: self)
			moveBrightnessSliderValueSelectorView(to: selectedPoint)
		default:
			break
		}
	}
	
	// MARK: - View size changes and rotation handling
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		setupGradientFrame()
		setSelectorPosition(brightness: color.brightness)
	}
}
