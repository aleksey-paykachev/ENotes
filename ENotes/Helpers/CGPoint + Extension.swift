//
//  CGPoint + Extension.swift
//  ENotes
//
//  Created by Aleksey on 14/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import CoreGraphics

extension CGPoint {
	
	/// Returuns a new instance of CGPoint placed inside the given rect.
	///
	/// - Parameter rect: A rectangle limiting original point constraint.
	/// - Returns: Clamped instance of CGPoint.
	///
	func clamped(in rect: CGRect) -> CGPoint {
		var clampedPoint = self

		if x < rect.minX {
			clampedPoint.x = rect.minX
		} else if x > rect.maxX {
			clampedPoint.x = rect.maxX
		}
		if y < rect.minY {
			clampedPoint.y = rect.minY
		} else if y > rect.maxY {
			clampedPoint.y = rect.maxY
		}

		return clampedPoint
	}
}
