//
//  AllNotesTableViewControllerCoordinator.swift
//  ENotes
//
//  Created by Aleksey on 18/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class ApplicationCoordinator {
	
	let rootViewController: UINavigationController
	
	init(window: UIWindow) {
		self.rootViewController = UINavigationController()
		window.makeKeyAndVisible()
	}
	
	func show() {
		let allNotesTableViewController = AllNotesTableViewController()
		let allNotesTableViewControllerCoordinator = AllNotesCoordinator(rootViewController: rootViewController, viewController: allNotesTableViewController)
		allNotesTableViewControllerCoordinator.show()
	}
}

class AllNotesCoordinator {
	
	let rootViewController: UINavigationController
	let viewController: AllNotesTableViewController
	
	init(rootViewController: UINavigationController, viewController: AllNotesTableViewController) {
		self.rootViewController = rootViewController
		self.viewController = viewController
	}
	
	func show() {
		rootViewController.pushViewController(viewController, animated: true)
	}
}
