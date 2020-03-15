//
//  RectangularSelectorView.swift
//  ENotes
//
//  Created by Aleksey on 14/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class RectangularSelectorView: UIView {
	
	convenience init(width: CGFloat, height: CGFloat) {
		self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
	}
	
	override func draw(_ rect: CGRect) {
		backgroundColor = nil
		
		let path = getPath()
		UIColor.white.setStroke()
		path.stroke()
		
		layer.shadowColor = UIColor.darkGray.cgColor
		layer.shadowOffset = .zero
		layer.shadowRadius = 1
		layer.shadowOpacity = 0.8
	}
	
	private func getPath() -> UIBezierPath {
		let minSide = min(bounds.width, bounds.height)
		let lineWidth = minSide * 0.3
		let path = UIBezierPath(rect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))

		path.lineWidth = lineWidth
		
		return path
	}
}
