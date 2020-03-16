//
//  MarkSignView.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Mark sign view. Animatable.
class MarkSignView: UIView {

	private let shapeLayer = CAShapeLayer()
	private let lineWidth: CGFloat = 5.0
	private let animationDuration: CFTimeInterval = 0.3
	
	private let shapeColor: UIColor = .white
	private let borderColor: UIColor = .darkGray
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	/// Show mark sign.
	/// - Parameter animated: If true, show mark sign with animation. Default value is true.
	///
	func show(animated: Bool = true) {
		shapeLayer.isHidden = false

		if animated {
			playAnimation()
		}
	}
	
	/// Hide mark sign.
	func hide() {
		shapeLayer.isHidden = true
	}
	
	private func setup() {
		backgroundColor = .clear
		shapeLayer.lineWidth = lineWidth
		shapeLayer.lineCap = .round
		shapeLayer.lineJoin = .round

		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = shapeColor.cgColor // inner shape
		shapeLayer.setShadow(radius: 1, color: borderColor) // outer border
		
		layer.addSublayer(shapeLayer)
		hide()
	}
	
	private func playAnimation() {
		let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
		
		animation.fromValue = 0.0
		animation.toValue = 1.0
		animation.duration = animationDuration
		
		shapeLayer.removeAnimation(forKey: "drawLineAnimation")
		shapeLayer.add(animation, forKey: "drawLineAnimation")
	}
	
	private func getMarkSignPath(in rect: CGRect) -> UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: lineWidth, y: rect.midY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - lineWidth))
		path.addLine(to: CGPoint(x: rect.maxX - lineWidth, y: lineWidth))

		return path
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		shapeLayer.path = getMarkSignPath(in: bounds).cgPath
	}
}
