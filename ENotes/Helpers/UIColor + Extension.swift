//
//  UIColor + Extension.swift
//  ENotes
//
//  Created by Aleksey on 14/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIColor {
	
	/// HSBColor represantation of the current color instance.
	var hsbColor: HSBColor {
		HSBColor(from: self)
	}
	
	/// Creates and returns a new instance of the original UIColor with changed value
	/// of the brightness.
	///
	/// - Parameter brightness: New brightness value.
	/// - Returns: A new instance of UIColor with new brightness value.
	///
	func withBrightness(_ brightness: CGFloat) -> UIColor {
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
		
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
	}
}


extension Optional where Wrapped == UIColor {
	
	/// Applys specified alpha component to given color object.
	/// - Parameters:
	///   - color: Initial color object.
	///   - alpha: The opacity of the new color object, specified as a value from 0.0 to 1.0.
	///
	static func += (color: inout Optional<UIColor>, alpha: CGFloat) {
		color = color?.withAlphaComponent(alpha)
	}
}


extension Array where Element == UIColor {

	/// Array of colors representing all hue color steps.
	static let hueComponents: [UIColor] =  [.red, .yellow, .green, .cyan, .blue, .magenta, .red]

	/// Creates and returns a new instance of the original UIColor array with changed value
	/// of the brightness for each color.
	///
	/// - Parameter brightness: New brightness value for all colors in the array.
	/// - Returns: A new instance of UIColor's array with new brightness value.
	///
	func withBrightness(_ brightness: CGFloat) -> [UIColor] {
		map { $0.withBrightness(brightness) }
	}
}
