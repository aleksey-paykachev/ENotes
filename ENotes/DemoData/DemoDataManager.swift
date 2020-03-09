//
//  DemoDataManager.swift
//  ENotes
//
//  Created by Aleksey on 09.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

/// Handles demo data for application
///
class DemoDataManager {

	/// Adds demo data to application on first startup
	///
	static func addDemoDataToApplication() {
		copyDemoNotebookIntoDocumentDirectory(from: "TextNoteNotebook")
		copyDemoNotebookIntoDocumentDirectory(from: "PhotoNoteNotebook")
	}
	
	private static func copyDemoNotebookIntoDocumentDirectory(from fileName: String, fileExtension: String = "json") {
		guard let sourceUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else { return }

		let destinationUrl = FileManager.documentDirectory.url(for: fileName, fileExtension: fileExtension)

		// Copy demo notebook file into document directory only if there is no one already
		guard !FileManager.default.fileExists(atPath: destinationUrl.path) else { return }
		
		do {
			try FileManager.default.copyItem(at: sourceUrl, to: destinationUrl)
		} catch {
			print("Could not copy demo data from file \(fileName).\(fileExtension)")
		}
	}
}
