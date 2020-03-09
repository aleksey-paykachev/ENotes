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
		copyDemoFileToDocumentDirectory(from: File(name: "TextNoteNotebook", ext: "json"))
		copyDemoFileToDocumentDirectory(from: File(name: "PhotoNoteNotebook", ext: "json"))
	}
	
	private static func copyDemoFileToDocumentDirectory(from file: File) {
		guard let sourceUrl = Bundle.main.url(forResource: file.name, withExtension: file.ext) else { return }

		let destinationUrl = FileManager.documentDirectory.url(for: file)

		// Copy demo notebook file into document directory only if there is no one already
		guard !FileManager.default.fileExists(atPath: destinationUrl.path) else { return }
		
		do {
			try FileManager.default.copyItem(at: sourceUrl, to: destinationUrl)
		} catch {
			print("Could not copy demo data from file \(file)")
		}
	}
}
