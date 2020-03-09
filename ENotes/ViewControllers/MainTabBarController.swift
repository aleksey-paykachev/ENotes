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
//		let textNotesNavigationViewController = UINavigationController()
		let textNotebook = Notebook<TextNote>()
		let textNotesViewController = TextNotesTableViewController(notebook: textNotebook)
//		textNotesNavigationViewController.pushViewController(textNotesViewController, animated: true)
		let textNotesNavigationViewController = UINavigationController(rootViewController: textNotesViewController)
		
		// Photo notes
//		let photoNotesNavigationViewController = UINavigationController()
		let photoNotebook = Notebook<PhotoNote>()
		let photoNotesViewController = PhotoNotesCollectionViewController(notebook: photoNotebook)
//		photoNotesNavigationViewController.pushViewController(photoNotesViewController, animated: true)
		let photoNotesNavigationViewController = UINavigationController(rootViewController: photoNotesViewController)

		// Tab bar
		setViewControllers([textNotesNavigationViewController, photoNotesNavigationViewController], animated: false)
	}
}
