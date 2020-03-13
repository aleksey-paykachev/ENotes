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
	
	private let selectionAnimationLayer = CAShapeLayer()
	private let selectedColorLayer = CAShapeLayer()

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupSelectionAnimationLayer()
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
	
	private func setupSelectionAnimationLayer() {
		addSubayerToColorCell(selectionAnimationLayer)
		selectionAnimationLayer.fillColor = UIColor.black.withAlphaComponent(0.3).cgColor
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
		longPressGesture.minimumPressDuration = 0.1 // duration before selection animation starts
		addGestureRecognizer(longPressGesture)
	}
		
	private func playSelectionAnimation() {
		let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
		animation.delegate = self

		animation.duration = 0.7
		animation.fromValue = CGPath.circle(center: colorCellView.bounds.center, radius: .zero)
		animation.toValue = CGPath.circle(in: colorCellView.bounds)
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		
		selectionAnimationLayer.add(animation, forKey: "SelectionAnimationLayerPathAnimation")
	}
	
	private func cancelSelectionAnimation() {
		selectionAnimationLayer.removeAllAnimations()
	}
	
	@objc private func cellBeingLongPressed(gesture: UILongPressGestureRecognizer) {
		// instead of telling delegate about ending of long press gesture immediately, start selection animation and watch for it's finished flag state.

		if gesture.state == .began {
			playSelectionAnimation()
		}
		
		if gesture.state == .ended {
			cancelSelectionAnimation()
		}
	}
}


// MARK: - CAAnimationDelegate

extension CustomColorSelectorCell: CAAnimationDelegate {
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		// animation did stop due to ending of long press gesture
		if flag {
			delegate?.customColorCellDidRecieveLongPress()
		}
	}
}
