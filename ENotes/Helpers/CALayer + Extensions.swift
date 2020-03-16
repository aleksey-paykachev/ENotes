//
//  CALayer + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 10.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension CALayer {
	
	/// Sets parameters to render the layer’s shadow.
	/// - Parameters:
	///   - radius: The blur radius (in points).
	///   - color: The color of the layer’s shadow.
	///   - offsetX: The x offset (in points) of the layer’s shadow. Default value is 0.
	///   - offsetY: The y offset (in points) of the layer’s shadow. Default value is 0.
	///   - alpha: The opacity of the layer’s shadow. Default value is 1.0 (no opacity).
	///
	func setShadow(radius: CGFloat, color: UIColor, offsetX: CGFloat = 0, offsetY: CGFloat = 0, alpha: CGFloat = 1) {

		shadowRadius = radius
		shadowColor = color.cgColor
		shadowOffset = CGSize(width: offsetX, height: offsetY)
		shadowOpacity = Float(alpha)
	}

	/// Sets parameters to render the layer’s border.
	/// - Parameters:
	///   - width: The width of the layer’s border.
	///   - color: The color of the layer’s border.
	///   - alpha: The opacity of the layer’s border. Default value is 1.0 (no opacity).
	///
	func setBorder(width: CGFloat, color: UIColor, alpha: CGFloat = 1) {
		borderWidth = width
		borderColor = color.withAlphaComponent(alpha).cgColor
	}
	
	/// Sets parameters to render the layer’s radius.
	/// - Parameters:
	///   - radius: The radius of rounded corners for the layer’s background.
	///   - maskToBounds: Clips sublayers to the layer’s bounds. Default value is true.
	///
	func setRadius(_ radius: CGFloat, maskToBounds: Bool = true) {
		self.cornerRadius = radius
		self.masksToBounds = maskToBounds
	}
	
	/// Sets parameters to render the layer’s gradient.
	/// - Parameters:
	///   - direction: The gradient direction.
	///   - colors: An array of color objects defining the color of each gradient stop.
	///
	func setGradient(direction: CAGradientLayer.Direction, colors: [UIColor]) {
		let gradientLayer = CAGradientLayer(direction: direction, colors: colors, frame: bounds)
		addSublayer(gradientLayer)
	}
}
