//
//  NotebookDataManager.swift
//  ENotes
//
//  Created by Aleksey on 14/10/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import Foundation

/// Abstract notebook data manager class. Needs implementation in subclass.
class NotebookDataManager<T: Note> {
	
	/// Loads and returns all notes.
	///
	/// - Returns: An array of loaded notes.
	///
	func load() -> [T] {
		fatalError("Abstract method. Needs implementation in subclass")
	}
	
	/// Saves given notes.
	///
	/// - Parameter notes: An array of notes to save.
	///
	func save(notes: [T]) {
		fatalError("Abstract method. Needs implementation in subclass")
	}
}
