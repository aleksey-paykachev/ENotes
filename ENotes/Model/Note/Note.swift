//
//  Note.swift
//  ENotes
//
//  Created by Aleksey on 20/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import Foundation

/// Generic note type
protocol Note {

	/// Parse JSON data and return new instance of a note.
	///
	/// - Parameter json: An array of JSON data contained all fields representing a note.
	/// - Returns: A new instance of a note or nil if JSON data could not be parsed.
	///
	static func parse(json: [String: Any]) -> Self?

	/// Unique note identifier.
	var uid: String { get }

	/// Representation of the note in JSON format.
	var json: [String: Any] { get }
}
