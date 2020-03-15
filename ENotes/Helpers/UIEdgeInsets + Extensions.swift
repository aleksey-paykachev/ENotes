//
//  UIEdgeInsets + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 15.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
	/// Creates a new instanse of the UIEdgeInsets with equal insets for all four edges.
	/// - Parameter inset: Inset value.
	///
	init(allEdges inset: CGFloat) {
		self.init(top: inset, left: inset, bottom: inset, right: inset)
	}
	
	/// Creates a new instanse of the UIEdgeInsets with equal horizontal and vertical insets.
	/// - Parameters:
	///   - horizontal: The horizontal inset value.
	///   - vertical: The vertical inset value.
	///
	init(horizontal: CGFloat, vertical: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
}
