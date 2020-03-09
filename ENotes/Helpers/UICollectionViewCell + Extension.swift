//
//  UICollectionViewCell + Extension.swift
//  ENotes
//
//  Created by Aleksey on 08/11/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
	
	/// String representation of the class name.
	static var className: String {
		return String(describing: self)
	}
	
	/// Reuse identifier for collection view.
	static var reuseIdentifier: String {
		return className + "ReuseIdentifier"
	}
}
