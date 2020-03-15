//
//  UITableViewCell + Extension.swift
//  ENotes
//
//  Created by Aleksey on 08/11/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UITableViewCell {
	
	/// String representation of the class name.
	static var className: String {
		String(describing: self)
	}
	
	/// Reuse identifier for table view.
	static var reuseIdentifier: String {
		className + "ReuseIdentifier"
	}
}
