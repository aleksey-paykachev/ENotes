//
//  CAGradientLayer + Extension.swift
//  ENotes
//
//  Created by Aleksey on 08/11/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class Z {
	let z = CAGradientLayer.Direction.fromLeftToRight
}

extension CAGradientLayer {
	
	/// Gradient direction.
	enum Direction {
		case fromLeftToRight
		case fromRightToLeft
		case fromTopToBottom
		case fromBottomToTop
	}
	
	/// Set gradient direction.
	///
	/// - Parameter direction: On of the standard gradient directions.
	///
	func setDirection(_ direction: Direction) {
		switch direction {
		case .fromLeftToRight:
			startPoint = CGPoint(x: 0, y: 0)
			endPoint = CGPoint(x: 1, y: 0)
		case .fromRightToLeft:
			startPoint = CGPoint(x: 1, y: 0)
			endPoint = CGPoint(x: 0, y: 0)
		case .fromTopToBottom:
			startPoint = CGPoint(x: 0, y: 0)
			endPoint = CGPoint(x: 0, y: 1)
		case .fromBottomToTop:
			startPoint = CGPoint(x: 0, y: 1)
			endPoint = CGPoint(x: 0, y: 0)
		}
	}
}
