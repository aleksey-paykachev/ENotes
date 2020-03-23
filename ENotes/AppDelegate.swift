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
	
	let freeVersionManager = FreeVersionManager(numberOfFreeNotesLimit: 18) // returns nil and does nothing for paid version
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Load demo data on first startup
		DemoDataManager.addDemoDataToApplication()

		// Create main window
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = MainTabBarController()
		window?.makeKeyAndVisible()
		
		return true
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		freeVersionManager?.checkForNotesLimitReached()
	}
}
