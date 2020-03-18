//
//  HSBColor.swift
//  ENotes
//
//  Created by Aleksey on 17/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

// We have to use a custom representation of a color because of the task 3.9 from the Yandex course, which ask us to save and restore position of all color selectors (Hue-Saturation selector and Brightness slider). We can't use standard UIColor because of its automatic conversion into different color schemes and lack of information about all three H-S-B components.


/// Custom color object specified in an extended color space.
/// Represents color using HSB components and the opacity.
///
struct HSBColor: Equatable {
	static let white = HSBColor(hue: 0, saturation: 0, brightness: 1)
	static let yellow = UIColor.yellow.hsbColor
	static let green = UIColor.green.hsbColor
	static let cyan = UIColor.cyan.hsbColor
	static let blue = HSBColor(hue: 0.6, saturation: 0.6, brightness: 1)
	static let indigo = HSBColor(hue: 0.7, saturation: 0.8, brightness: 1)
	static let magenta = UIColor.magenta.hsbColor
	static let red = HSBColor(hue: 0, saturation: 0.8, brightness: 1)
	static let orange = HSBColor(hue: 0.1, saturation: 0.9, brightness: 1)
	static let brown = HSBColor(hue: 0.1, saturation: 0.9, brightness: 0.7)
	static let gray = UIColor.gray.hsbColor
	static let lightGray = UIColor.lightGray.hsbColor

	var hue: CGFloat
	var saturation: CGFloat
	var brightness: CGFloat
	var alpha: CGFloat
	
	/// Returns a custom color object using HSB color component values and the opacity.
	/// The color is specified in an extended color space, and the input values are
	/// never clamped.
	///
	init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat = 1) {
		self.hue = hue
		self.saturation = saturation
		self.brightness = brightness
		self.alpha = alpha
	}
	
	/// Returns a custom HSB color object created from a given instance of the UIColor class.
	///
	init(from uiColor: UIColor) {
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0

		uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

		self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
	}
	
	/// Returns a custom HSB color, or nil, if color components dictionary provided in
	/// wrong format.
	///
	/// - Parameter colorComponents: dictionary, contaned all four color components: hue,
	///				saturation, brightness and alpha.
	///
	init?(from colorComponents: [String: CGFloat]) {
		guard let hue = colorComponents["hue"],
			let saturation = colorComponents["saturation"],
			let brightness = colorComponents["brightness"],
			let alpha = colorComponents["alpha"] else {
				return nil
		}
		
		self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
	}
	
	/// The UIColor representation of current HSBColor.
	var uiColor: UIColor {
		UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
	}
	
	/// The CGColor representation of current HSBColor.
	var cgColor: CGColor {
		uiColor.cgColor
	}
	
	/// Dictionary representation of all color components: hue, saturation, brightness and alpha.
	var colorComponents: [String: CGFloat] {
		["hue": hue, "saturation": saturation, "brightness": brightness, "alpha": alpha]
	}
}
