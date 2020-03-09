//
//  Notebook.swift
//  ENotes
//
//  Created by Aleksey on 04/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import Foundation

/// Notebook represents a data structure for storing multiple notes of the same kind.
/// Each instance of notebook can store only one type of notes (i.e. text, photo, etc)
/// and can not mix them.
///
class Notebook<T: Note> {

	private var notes: [T] = []
	private let dataManager: NotebookDataManager<T>
	
	/// Returns a notebook.
	///
	/// - Parameter dataManager: Data manager are used for persistant storing this notebook.
	/// Default implementation uses file data manager.
	///
	init(dataManager: NotebookDataManager<T> = NotebookFileDataManager<T>()) {
		self.dataManager = dataManager
		
		loadNotebook()
	}

	/// Number of notes in current notebook.
	var count: Int {
		notes.count
	}
	
	/// Returns a note by its index in current notebook. Crashes if given index doesn't exist.
	///
	/// - Complexity: O(1).
	/// - Parameter index: Index of the note inside current notebook.
	/// - Returns: Note.
	///
	func get(by index: Int) -> T {
		notes[index]
	}
	
	/// Returns the index of the given note in current notebook.
	///
	/// - Complexity: O(n), where n is the number of notes in current notebook.
	/// - Parameter note: The note, which unique identifier (uid) are used to find an index.
	/// - Returns: The index of the note in current notebook, or nil if there is no such.
	///
	func getIndex(by note: T) -> Int? {
		notes.firstIndex { $0.uid == note.uid }
	}
	
	/// Adds a note at the end of the notebook.
	///
	/// - Complexity: O(n), where n is the number of notes in current notebook. This check
	///   is neccessary to preserve unique identifiers for each note.
	/// - Parameter note: The note to add.
	///
	func add(_ note: T) {
		guard getIndex(by: note) == nil else { return }
		
		notes.append(note)
		saveNotebook()
		postNotification(.addNote)
	}
	
	/// Updates the note inside current notebook. Do nothing if there isn't such note.
	///
	/// - Complexity: O(n), where n is the number of notes in current notebook.
	/// - Parameter note: The note to update.
	///
	func update(_ note: T) {
		guard let index = getIndex(by: note) else { return }
		
		notes[index] = note
		saveNotebook()
	}
	
	/// Remove note by its index inside current notebook.
	///
	/// - Complexity: O(n), where n is the number of notes in current notebook.
	/// - Parameter index: Notebook index of the note to delete.
	///
	func remove(at index: Int) {
		notes.remove(at: index)
		saveNotebook()
		postNotification(.removeNote)
	}

	/// Move note to new location inside notebook.
	///
	/// - Complexity: O(n), where n is the number of notes in current notebook.
	/// - Parameters:
	///   - sourceIndex: Notebook original (sorce) index of the note.
	///   - destinationIndex: Notebook new (destination) index of the note.
	///
	func moveNoteByIndex(from sourceIndex: Int, to destinationIndex: Int) {
		let note = notes.remove(at: sourceIndex)
		notes.insert(note, at: destinationIndex)
		saveNotebook()
	}
}


// MARK: - Data manager

// Loads and saves entire notebook using data manager provided with notebook class initializer.
extension Notebook {
	private func loadNotebook() {
		notes = dataManager.load()
	}
	
	private func saveNotebook() {
		dataManager.save(notes: notes)
	}
}


// MARK: - Notifications

extension Notebook {
	// Notification mechanism are used to notify an instance of FreeVersionManager about note creation or deletion. We can't use static variables to get all notes count, because of generic type of Notebook class.

	private func postNotification(_ notificationType: FreeVersionManager.NotificationType) {
		NotificationCenter.default.post(name: notificationType.notificationName, object: nil)
	}
}
