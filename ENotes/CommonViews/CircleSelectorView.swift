//
//  CircleSelectorView.swift
//  ENotes
//
//  Created by Aleksey on 13/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Circle selector view - circle with inner concentric circle inside.
class CircleSelectorView: UIView {
	
	private let shapeColor: UIColor = .white
	private let borderColor: UIColor = .darkGray
	private let lineWidthToOuterRadiusRatio: CGFloat = 0.4
	
	convenience init(radius: CGFloat) {
		self.init(frame: CGRect(origin: .zero, size: .square(radius * 2)))
	}
	
	/// Radius value of the outer circle.
	var radius: CGFloat {
		bounds.width / 2
	}
	
	override func draw(_ rect: CGRect) {
		backgroundColor = nil

		let path = getPath()
		shapeColor.setStroke() // inner shape color
		path.stroke()
		
		layer.setShadow(radius: 1, color: borderColor, alpha: 0.8) // outer border
	}
	
	private func getPath() -> UIBezierPath {
		let lineWidth = radius * lineWidthToOuterRadiusRatio

		let pathRadius = radius - lineWidth / 2
		let center = CGPoint(x: radius, y: radius)
		let path = UIBezierPath(arcCenter: center, radius: pathRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
		
		path.lineWidth = lineWidth
		
		return path
	}
}
