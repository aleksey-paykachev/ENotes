//
//  UIImage + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 09.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UIImage {

	/// Data object containing the specified image in JPEG format with the default
	/// compression quality.
	///
	var jpegData: Data? {
		jpegData(compressionQuality: 0.8)
	}
}
