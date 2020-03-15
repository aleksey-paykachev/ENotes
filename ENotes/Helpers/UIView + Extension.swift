//
//  UIView + Extension.swift
//  ENotes
//
//  Created by Aleksey on 17/11/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIView {
	
	/// Constraints current view to the second view with the given insets.
	///
	/// - Parameters:
	///   - secondView: Second view which current view are constraints to.
	///   - insets: Edge insets.
	///
	func constraint(to secondView: UIView, with insets: UIEdgeInsets = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: secondView.topAnchor, constant: insets.top),
			trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -insets.right),
			bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -insets.bottom),
			leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: insets.left)
		])
	}
	
	/// Constraints current view to the second view with the given inset equal for all
	/// four directions.
	///
	/// - Parameters:
	///   - secondView: Second view which current view are constraints to.
	///   - inset: Top, left, bottom and right equal edge inset.
	///
	func constrain(to secondView: UIView, withAllEdgesInsets inset: CGFloat) {
		constraint(to: secondView, with: UIEdgeInsets(allEdges: inset))
	}
}
