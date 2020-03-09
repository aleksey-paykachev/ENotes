//
//  Bundle.swift
//  ENotes
//
//  Created by Aleksey on 09.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension Bundle {
	
	/// Returns the file URL for the resource identified by the specified file.
	/// - Parameter file: Recource file.
	/// - Returns: The file URL for the resource file or nil if the file could not be located.
	///
	func url(for file: File) -> URL? {
		url(forResource: file.name, withExtension: file.ext)
	}
}
