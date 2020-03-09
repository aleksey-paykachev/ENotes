//
//  CGRect + Extension.swift
//  ENotes
//
//  Created by Aleksey on 12/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import CoreGraphics

extension CGRect {
	
	/// Returns a square: CGRect with equal width and hight with zero origin.
	static func square(size: CGFloat) -> CGRect {
		return CGRect(origin: .zero, size: CGSize(width: size, height: size))
	}

	/// Returns a rectangle CGRect with given width, hight and zero origin.
	static func rectangle(width: CGFloat, height: CGFloat) -> CGRect {
		return CGRect(origin: .zero, size: CGSize(width: width, height: height))
	}

	/// Scales and returns a new CGRect with the given scale and placed at the center
	/// of the original CGRect.
	///
	/// - Parameter scale: New scale ratio.
	/// - Returns: New CGRect instance, scaled to the given scale.
	func scaled(to scale: CGFloat) -> CGRect {
		return CGRect(x: origin.x + width * (1 - scale) / 2,
					  y: origin.y + height * (1 - scale) / 2,
					  width: width * scale,
					  height: height * scale)
	}
}
