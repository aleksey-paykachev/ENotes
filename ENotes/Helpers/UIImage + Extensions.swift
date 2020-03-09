//
//  UIImage + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 09.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIImage {
	
	/// Default value of jpeg-compressed images quality, from 0.0 to 1.0.
	static let defaultJpegQuality: CGFloat = 0.8

	/// Data object containing the specified image in JPEG format with the default
	/// compression quality.
	///
	var jpegData: Data? {
		jpegData(compressionQuality: Self.defaultJpegQuality)
	}
}
