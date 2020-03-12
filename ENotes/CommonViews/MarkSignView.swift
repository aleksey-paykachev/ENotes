//
//  MarkSignView.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class MarkSignView: UIView {

	private let shapeLayer = CAShapeLayer()
	private let lineWidth: CGFloat = 5.0
	private let animationDuration: CFTimeInterval = 0.3
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	func show() {
		shapeLayer.isHidden = false
		playAnimation()
	}
	
	func hide() {
		shapeLayer.isHidden = true
	}
	
	private func setup() {
		backgroundColor = .clear
		shapeLayer.lineWidth = lineWidth
		shapeLayer.lineCap = .round
		shapeLayer.lineJoin = .round

		shapeLayer.strokeColor = UIColor.white.cgColor
		shapeLayer.fillColor = nil
		
		shapeLayer.shadowColor = UIColor.darkGray.cgColor
		shapeLayer.shadowOffset = .zero
		shapeLayer.shadowRadius = 1
		shapeLayer.shadowOpacity = 1
		
		layer.addSublayer(shapeLayer)
		hide()
	}
	
	private func playAnimation() {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		
		animation.fromValue = 0.0
		animation.toValue = 1.0
		animation.duration = animationDuration
		
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = true

		shapeLayer.removeAnimation(forKey: "drawLineAnimation")
		shapeLayer.add(animation, forKey: "drawLineAnimation")
	}
	
	private func getMarkSignPath(in rect: CGRect) -> UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0 + lineWidth, y: rect.midY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - lineWidth))
		path.addLine(to: CGPoint(x: rect.maxX - lineWidth, y: 0 + lineWidth))

		return path
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		shapeLayer.path = getMarkSignPath(in: bounds).cgPath
	}
}
