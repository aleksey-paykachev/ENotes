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

	private var color: HSBColor = .white
	private let brightnessGradient = CAGradientLayer(direction: .fromLeftToRight, colors: [])
	private let sliderSelectorView = RectangularSelectorView(width: 20, height: 60)

	weak var delegate: BrightessSliderViewDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupGradient()
		setupSelector()
		setupGestures()
	}
	
	// MARK: - Public API
	
	/// Set currently selected color.
	/// Changes gradient and moves slider according to selected color.
	///
	func set(color: HSBColor) {
		self.color = color

		updateGradient()
		updateSelectorPosition()
	}
	
	// MARK: - Setup
	
	private func setupGradient() {
		layer.addSublayer(brightnessGradient)
		updateGradientFrame()
	}
	
	private func setupSelector() {
		sliderSelectorView.isOpaque = false
		addSubview(sliderSelectorView)
	}
	
	private func updateGradientFrame() {
		// add little insets to gradient layer to prevent overlapping with the border
		brightnessGradient.frame = bounds.insetBy(dx: 1, dy: 1)
	}
	
	private func setupGestures() {
		let panBrightnessSliderGesture = UIPanGestureRecognizer(target: self, action: #selector(selectBrightnessByGesture))
		let tapBrightnessSliderGesture = UITapGestureRecognizer(target: self, action: #selector(selectBrightnessByGesture))
		
		addGestureRecognizer(panBrightnessSliderGesture)
		addGestureRecognizer(tapBrightnessSliderGesture)
	}
	
	// MARK: - Update UI
	
	private func updateSelectorPosition() {
		let selectorHalfWidth = sliderSelectorView.bounds.width / 2
		sliderSelectorView.frame.origin.x = bounds.width * color.brightness - selectorHalfWidth
	}
	
	private func updateGradient() {
		brightnessGradient.setColors([.black, color.uiColor])
	}

	private func moveBrightnessSliderValueSelectorView(to point: CGPoint) {
		let horizontalPositionInBounds = point.clamped(in: bounds).x
		
		color.brightness = horizontalPositionInBounds / bounds.width
		updateSelectorPosition()
		
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
		
		updateGradientFrame()
		updateSelectorPosition()
	}
}
