//
//  App.swift
//  ENotes
//
//  Created by Aleksey on 17.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

/// Class for application-related helper functions.
class App {

	/// Log given message. Current implementation prints filename and message to the console.
	/// - Parameters:
	///   - message: Logged message.
	///   - functionName: Name of the function sended message.
	///
	static func log(_ message: String, functionName: StaticString = #function) {
		print("APP LOG:", functionName, "-", message)
	}
}
