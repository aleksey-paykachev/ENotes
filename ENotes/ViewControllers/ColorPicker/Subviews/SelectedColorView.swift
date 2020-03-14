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
		setup()
	}
	
	private func setup() {
		layer.setRadius(8)
		layer.setBorder(width: 1, color: .darkGray)
	}
	
	func set(color: HSBColor) {
		backgroundColor = color.uiColor
	}
}
