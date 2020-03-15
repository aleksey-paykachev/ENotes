//
//  FileManager + Extension.swift
//  EENotes
//
//  Created by Aleksey on 06/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension FileManager {
	
	/// User document directory.
	static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
