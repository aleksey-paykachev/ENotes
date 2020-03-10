//
//  DataManager.swift
//  ENotes
//
//  Created by Aleksey on 10.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

/// Data Manager singleton class holding all data-related objects.
///
class DataManager {

	/// Shared instance of DataManager.
	static let shared = DataManager()
	
	/// Text notebook used in the application.
	let textNotebook = Notebook<TextNote>()
	
	/// Photo notebook used in the application.
	let photoNotebook = Notebook<PhotoNote>()

	private init() { } // singleton
}
