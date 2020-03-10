//
//  CALayer + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 10.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension CALayer {
	
	/// Set parameters to render the layer’s shadow.
	/// - Parameters:
	///   - radius: The blur radius (in points).
	///   - color: The color of the layer’s shadow.
	///   - offsetX: The x offset (in points) of the layer’s shadow.
	///   - offsetY: The y offset (in points) of the layer’s shadow.
	///   - alpha: The opacity of the layer’s shadow.
	///
	func setShadow(radius: CGFloat, color: UIColor, offsetX: CGFloat = 0, offsetY: CGFloat = 0, alpha: CGFloat = 1) {

		shadowRadius = radius
		shadowColor = color.cgColor
		shadowOffset = CGSize(width: offsetX, height: offsetY)
		shadowOpacity = Float(alpha)
	}

	/// Set parameters to render the layer’s border.
	/// - Parameters:
	///   - width: The width of the layer’s border.
	///   - color: The color of the layer’s border.
	///   - alpha: The alpha of the layer’s border.
	///
	func setBorder(width: CGFloat, color: UIColor, alpha: CGFloat) {
		borderWidth = width
		borderColor = color.withAlphaComponent(alpha).cgColor
	}
	
	/// Set parameters to render the layer’s radius.
	/// - Parameters:
	///   - radius: The radius of rounded corners for the layer’s background.
	///   - maskToBounds: Clips sublayers to the layer’s bounds. Default value is true.
	///
	func setRadius(_ radius: CGFloat, maskToBounds: Bool = true) {
		self.cornerRadius = radius
		self.masksToBounds = maskToBounds
	}
	
	/// Set parameters to render the layer’s gradient.
	/// - Parameters:
	///   - direction: The gradient direction.
	///   - colors: An array of color objects defining the color of each gradient stop.
	///
	func setGradient(direction: CAGradientLayer.Direction, colors: [UIColor]) {
		let gradient = CAGradientLayer()
		gradient.setDirection(direction)
		gradient.colors = colors.map { $0.cgColor }
		gradient.frame = bounds

		addSublayer(gradient)
	}
}
