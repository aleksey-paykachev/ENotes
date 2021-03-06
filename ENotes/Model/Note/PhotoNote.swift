//
//  PhotoNote.swift
//  ENotes
//
//  Created by Aleksey on 18/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

struct PhotoNote: Note {
	
	let uid: String
	private let imageData: Data
	
	/// Photo note image.
	var image: UIImage? {
		UIImage(data: imageData)
	}
	
	/// Photo note thumbnail image.
	var thumbnail: UIImage? {
		UIImage(data: imageData, scale: 0.1)
	}
	
	/// Initialize a new photo note from image data.
	///
	/// - Parameters:
	///   - uid: Unique identifier. If ommited, generates automaticaly.
	///   - imageData: Data of the note's photo image.
	///
	init(uid: String = UUID().uuidString, imageData: Data) {
		self.uid = uid
		self.imageData = imageData
	}

	/// Initialize a new photo note from existing image.
	///
	/// - Parameters:
	///   - uid: Unique identifier. If ommited, generates automaticaly.
	///   - image: Photo image of the note.
	///
	init?(uid: String = UUID().uuidString, image: UIImage) {
		guard let imageData = image.jpegData else { return nil }

		self.init(uid: uid, imageData: imageData)
	}
	
	// MARK: - Custom JSON serialization and deserialization.
	// Restriction on usage of Encodable and Decodable protocols comes from Yandex.

	static func parse(json: [String: Any]) -> PhotoNote? {
		let uid = json["uid"] as? String
		let imageDataString = json["imageData"] as? String
		let imageData = Data(base64Encoded: imageDataString ?? "")

		if let uid = uid, let imageData = imageData {
			return PhotoNote(uid: uid, imageData: imageData)
		}

		return nil
	}

	/// An array of JSON data containing all fields representing a photo note.
	var json: [String: Any] {

		var json: [String: Any] = [:]
		json["uid"] = uid
		json["imageData"] = image?.jpegData?.base64EncodedString()
		
		return json
	}
}
