//
//  CGSize + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 12.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import CoreGraphics

extension CGSize {

	/// Returns a square: CGRect with equal width and height.
	static func square(_ sideSize: CGFloat) -> CGSize {
		CGSize(width: sideSize, height: sideSize)
	}
}
