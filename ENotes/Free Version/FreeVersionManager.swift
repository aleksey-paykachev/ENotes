//
//  FreeVersionManager.swift
//  ENotes
//
//  Created by Aleksey on 16/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FreeVersionManager {
	
	private let numberOfFreeNotesLimit: Int
	private var currentNotesCount = 0
	
	private var freeNotesLeft: Int {
		numberOfFreeNotesLimit - currentNotesCount
	}
	
	/// Setup version type of software based on build configuration custom flag FREE_VERSION.
	/// For free version starts observing for total notes count change for all types of
	/// notebooks, and shows modal window when limit has been reached.
	/// For paid version returns nil and does nothing.
	/// - Parameter numberOfFreeNotesLimit: Total number of free notes limit (text and photo).
	///
	init?(numberOfFreeNotesLimit: Int) {
		#if FREE_VERSION
			self.numberOfFreeNotesLimit = numberOfFreeNotesLimit
			notesLimitChecker()
		#else
			return nil
		#endif
	}
	
	/// Check if notes limit has been reached, and show modal window if so.
	func checkForNotesLimitReached() {
		if freeNotesLeft <= 0 {
			showEndOfFreeTrialModal()
		}
	}
	
	private func showEndOfFreeTrialModal() {
		let rootViewController = UIApplication.shared.keyWindow?.rootViewController
		
		if !(rootViewController?.presentedViewController is EndOfFreeTrialViewController) {
			let endOfFreeTrialViewController = EndOfFreeTrialViewController()
			endOfFreeTrialViewController.modalPresentationStyle = .fullScreen
			rootViewController?.present(endOfFreeTrialViewController, animated: true)
		}
	}
	
	private func notesLimitChecker() {
		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(forName: .addNote, object: nil, queue: .main) { _ in
			self.currentNotesCount += 1
			self.checkForNotesLimitReached()
			App.log("Add new note. Free notes left: \(self.freeNotesLeft)")
		}
		
		notificationCenter.addObserver(forName: .removeNote, object: nil, queue: .main) { _ in
			self.currentNotesCount -= 1
			App.log("Remove existing note. Free notes left: \(self.freeNotesLeft)")
		}
	}
}


extension Notification.Name {
	static let addNote = Notification.Name(rawValue: "NoteAddedNotification")
	static let removeNote = Notification.Name(rawValue: "NoteRemovedNotification")
}
