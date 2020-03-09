//
//  UIColor + Extension.swift
//  ENotes
//
//  Created by Aleksey on 14/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIColor {
	
	/// HSBColor represantation of current color instance.
	var hsbColor: HSBColor {
		return HSBColor(from: self)
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
	
	/// Creates and returns a new instance of CGColor from the original UIColor with
	/// changed value of the brightness.
	///
	/// - Parameter brightness: New brightness value.
	/// - Returns: An instance of CGColor with new brightness value.
	func cgColorWithBrightness(_ brightness: CGFloat) -> CGColor {
		return self.withBrightness(brightness).cgColor
	}
}
