//
//  Comparable + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 16.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension Comparable {

	/// Calculates and returns a new value, limited by provided bounds range.
	/// - Parameter bounds: The bounds range for value to limit.
	/// - Returns: Clamped value.
	///
	func clamped(in bounds: ClosedRange<Self>) -> Self {
		min(max(self, bounds.lowerBound), bounds.upperBound)
	}
}
