//
//  RectangularSelectorView.swift
//  ENotes
//
//  Created by Aleksey on 14/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Rectangulr selector view - rectangle with inner rectangular hole in it.
class RectangularSelectorView: UIView {
	
	private let shapeColor: UIColor = .white
	private let borderColor: UIColor = .darkGray
	private let lineWidthToShapeWidthRatio: CGFloat = 0.3
	
	convenience init(width: CGFloat, height: CGFloat) {
		self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
	}
	
	override func draw(_ rect: CGRect) {
		backgroundColor = nil
		
		let path = getPath()
		shapeColor.setStroke() // inner shape color
		path.stroke()
		
		layer.setShadow(radius: 1, color: borderColor, alpha: 0.8) // outer border
	}
	
	private func getPath() -> UIBezierPath {
		let minSide = min(bounds.width, bounds.height)
		let lineWidth = minSide * lineWidthToShapeWidthRatio
		let path = UIBezierPath(rect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))

		path.lineWidth = lineWidth
		
		return path
	}
}
