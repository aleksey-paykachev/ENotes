//
//  SelectedColorView.swift
//  ENotes
//
//  Created by Aleksey on 11/10/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class SelectedColorView: UIView {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		layer.borderColor = UIColor.darkGray.cgColor
		layer.borderWidth = 1
		layer.cornerRadius = 8
	}
	
	func set(color: HSBColor) {
		backgroundColor = color.uiColor
	}
}
