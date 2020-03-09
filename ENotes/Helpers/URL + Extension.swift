//
//  URL + Extension.swift
//  ENotes
//
//  Created by Aleksey on 24/12/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension URL {
	
	/// Forms and returns an URL of the given file name and extension relative to current URL
	///
	/// - Parameters:
	///   - fileName: File name.
	///   - fileExtension: File extension.
	/// - Returns: URL of the file.
	///
	func url(for fileName: String, fileExtension: String) -> URL {
		return appendingPathComponent(fileName).appendingPathExtension(fileExtension)
	}
}
