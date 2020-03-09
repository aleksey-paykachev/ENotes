//
//  AppDelegate.swift
//  ENotes
//
//  Created by Aleksey on 03/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	let freeVersionManager = FreeVersionManager() // returns nil and does nothing for paid version
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Load demo data on first startup
		copyDemoNotebookIntoDocumentDirectory(from: "TextNoteNotebook")
		copyDemoNotebookIntoDocumentDirectory(from: "PhotoNoteNotebook")

		// Create main window
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = MainTabBarController()
		window?.makeKeyAndVisible()
		
		return true
	}
	
	private func copyDemoNotebookIntoDocumentDirectory(from fileName: String, fileExtension: String = "json") {
		guard let sourceUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else { return }

		let destinationUrl = FileManager.documentDirectory.url(for: fileName, fileExtension: fileExtension)

		// Copy demo notebook file into document directory only if there is no one already
		if !FileManager.default.fileExists(atPath: destinationUrl.path) {
			do {
				try FileManager.default.copyItem(at: sourceUrl, to: destinationUrl)
			} catch {
				print("Could not copy demo data from file \(fileName).\(fileExtension)")
			}
		}
	}
}
