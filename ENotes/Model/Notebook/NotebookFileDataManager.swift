//
//  NotebookFileDataManager.swift
//  ENotes
//
//  Created by Aleksey on 14/10/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import Foundation

// Restriction on usage of Encodable and Decodable protocols comes from Yandex.

/// File data manager are used to save and load the whole notebook as a single file.
///
class NotebookFileDataManager<T: Note>: NotebookDataManager<T> {

	private let fileName = File(name: "\(T.self)Notebook", ext: "json") // NoteTypeNotebook.json
	private lazy var fileUrl = FileManager.documentDirectory.url(for: fileName)
	
	override func load() -> [T] {
		guard FileManager.default.fileExists(atPath: fileUrl.path) else { return [] }

		var notes: [T] = []

		do {
			let data = try Data(contentsOf: fileUrl)
			let notesJSON = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]

			notes = notesJSON?.compactMap(T.parse) ?? []
			
		} catch {
			print("Can't load notes from notebook file. Error: \(error.localizedDescription)")
		}
		
		return notes
	}
	
	override func save(notes: [T]) {
		// move expensive save operation to different queue
		
		DispatchQueue.global(qos: .userInitiated).async {
			let notesJSON = notes.map { $0.json }

			do {
				let data = try JSONSerialization.data(withJSONObject: notesJSON)
				try data.write(to: self.fileUrl, options: .atomic)

			} catch {
				print("Can't save notes to notebook file. Error: \(error.localizedDescription)")
			}
		}
	}
}
