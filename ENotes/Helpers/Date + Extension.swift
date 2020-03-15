//
//  Date + Extension.swift
//  ENotes
//
//  Created by Aleksey on 08/11/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension Date {

	/// Localized string representation of the current date using short date format style.
	var shortFormatString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short

		return dateFormatter.string(from: self)
	}
}
