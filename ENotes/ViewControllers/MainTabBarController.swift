//
//  MainTabBarController.swift
//  ENotes
//
//  Created by Aleksey on 18/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Text notes
		let textNotebook = DataManager.shared.textNotebook
		let textNotesViewController = TextNotesViewController(notebook: textNotebook)
		let textNotesNavigationController = UINavigationController(rootViewController: textNotesViewController)
		
		// Photo notes
		let photoNotebook = DataManager.shared.photoNotebook
		let photoNotesViewController = PhotoNotesViewController(notebook: photoNotebook)
		let photoNotesNavigationController = UINavigationController(rootViewController: photoNotesViewController)

		// Tab bar
		viewControllers = [textNotesNavigationController, photoNotesNavigationController]
	}
}
