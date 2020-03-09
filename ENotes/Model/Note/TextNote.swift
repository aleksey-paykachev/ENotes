//
//  TextNote.swift
//  ENotes
//
//  Created by Aleksey on 03/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Text note.
struct TextNote: Note {
	
	/// An empty instance of text note without a title and content.
	static var empty: TextNote {
		return TextNote(title: "", content: "")
	}
	
	// Variables
	let uid: String
	let title: String
	let content: String
	let color: HSBColor
	let selfDestructionDate: Date?
	
	/// Initialize a new text note.
	///
	/// - Parameters:
	///   - uid: Unique identifier. If ommited, generates automaticaly.
	///   - title: Title of the note.
	///   - content: Content of the note.
	///   - color: Color assosiated with the note.
	///   - selfDestructionDate: If value is not nil, created note will automatiacly be
	///		deleted at this date.
	///
	init(uid: String? = nil, title: String, content: String, color: HSBColor? = nil, selfDestructionDate: Date? = nil) {
		
		self.uid = uid ?? UUID().uuidString
		self.title = title
		self.content = content
		self.color = color ?? .white
		self.selfDestructionDate = selfDestructionDate
	}

	
	// MARK: - Custom JSON serialization and deserialization.
	// Restriction on usage of Encodable and Decodable protocols comes from Yandex.

	static func parse(json: [String: Any]) -> TextNote? {
		// Reqired fields of the TextNote structure initializer
		guard let title = json["title"] as? String,
			  let content = json["content"] as? String else { return nil }
		
		// Other (optional) fields
		let uid = json["uid"] as? String
		
		let colorComponents = json["color"] as? [String: CGFloat] ?? [:]
		let color = HSBColor(from: colorComponents)

		let selfDestructionDate = (json["selfDestructionDate"] as? TimeInterval).map {
			Date(timeIntervalSince1970: $0)
		}
		
		// finaly init and return TextNote instance
		return TextNote(uid: uid, title: title, content: content, color: color, selfDestructionDate: selfDestructionDate)
	}
	
	/// An array of JSON data contained all fields representing a text note.
	var json: [String: Any] {

		var json: [String: Any] = [:]
		json["uid"] = uid
		json["title"] = title
		json["content"] = content
		json["color"] = color == .white ? nil : color.colorComponents
		json["selfDestructionDate"] = selfDestructionDate?.timeIntervalSince1970
		
		return json
	}
}
