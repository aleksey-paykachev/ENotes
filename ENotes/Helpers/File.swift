//
//  File.swift
//  ENotes
//
//  Created by Aleksey on 09.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

struct File {
	let name: String
	let ext: String
}


// MARK: - CustomStringConvertible

extension File: CustomStringConvertible {

	var description: String {
		ext.isEmpty ? name : "\(name).\(ext)"
	}
}
