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
	/// - Parameter rect: A rectangle limiting original point.
	/// - Returns: Clamped instance of CGPoint.
	///
	func clamped(in rect: CGRect) -> CGPoint {
		CGPoint(x: x.clamped(in: rect.minX...rect.maxX),
				y: y.clamped(in: rect.minY...rect.maxY))
	}
}
