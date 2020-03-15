//
//  File.swift
//  ENotes
//
//  Created by Aleksey on 09.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

/// Structure describing file entity.
struct File {
	/// File name.
	let name: String
	
	/// File extension.
	let ext: String
}


// MARK: - CustomStringConvertible

extension File: CustomStringConvertible {

	/// Description containing full file name.
	var description: String {
		ext.isEmpty ? name : "\(name).\(ext)"
	}
}
