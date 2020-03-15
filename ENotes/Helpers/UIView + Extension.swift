//
//  UIView + Extension.swift
//  ENotes
//
//  Created by Aleksey on 17/11/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIView {
	
	/// Constraints current view to the super view with the given insets.
	///
	/// - Parameters:
	///   - superView: Super view which current view are constraints to.
	///   - insets: Edge insets.
	///
	func constraint(to superView: UIView, with insets: UIEdgeInsets = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top),
			trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -insets.right),
			bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -insets.bottom),
			leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left)
			])
	}
	
	/// Constraints current view to the super view with the given inset equal to all
	/// four directions.
	///
	/// - Parameters:
	///   - superView: Super view which current view are constraints to.
	///   - inset: Top, left, bottom and right equal edge inset.
	func constrain(to superView: UIView, withAllEdgesInsets inset: CGFloat) {
		constraint(to: superView, with: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
	}
}
