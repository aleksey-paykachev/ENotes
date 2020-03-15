//
//  CircleSelectorView.swift
//  ENotes
//
//  Created by Aleksey on 13/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class CircleSelectorView: UIView {
	
	convenience init(radius: CGFloat) {
		self.init(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
	}
	
	var radius: CGFloat {
		bounds.width / 2
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
		let lineWidth = minSide * 0.2

		let radius = (minSide - lineWidth) / 2
		let center = CGPoint(x: radius + lineWidth / 2, y: radius + lineWidth / 2)
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
		
		path.lineWidth = lineWidth
		
		return path
	}
}
