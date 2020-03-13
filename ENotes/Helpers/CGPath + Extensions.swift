//
//  CGPath + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 12.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import CoreGraphics

extension CGPath {
	
	/// Creates and returns circle path in given rect with given scale factor.
	/// - Parameter rect: The rectangle that bounds the circle.
	///
	static func circle(in rect: CGRect) -> CGPath {
		CGPath(ellipseIn: rect, transform: nil)
	}
	
	/// Creates and returns circle path at the given center with given radius.
	/// - Parameters:
	///   - center: The center point of the circle.
	///   - radius: The radius of the circle.
	static func circle(center: CGPoint, radius: CGFloat) -> CGPath {
		circle(in: CGRect(origin: center, size: CGSize(width: radius * 2, height: radius * 2)))
	}
}
