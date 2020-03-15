//
//  CAGradientLayer + Extension.swift
//  ENotes
//
//  Created by Aleksey on 08/11/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension CAGradientLayer {
	
	/// Gradient direction.
	enum Direction {
		case fromLeftToRight
		case fromRightToLeft
		case fromTopToBottom
		case fromBottomToTop
	}
	
	/// Creates and returns gradient layer with specified parameters.
	/// - Parameters:
	///   - direction: The gradient direction.
	///   - colors: An array of color objects defining the color of each gradient stop.
	///   - frame: The frame of the gradient layer.
	///
	convenience init(direction: Direction, colors: [UIColor], frame: CGRect = .zero) {
		self.init()
		
		setDirection(direction)
		setColors(colors)
		self.frame = frame
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
	
	/// Set an array of color objects defining the color of each gradient stop.
	/// - Parameter colors: Colors defining gradient stops.
	///
	func setColors(_ colors: [UIColor]) {
		self.colors = colors.map { $0.cgColor }
	}
}
