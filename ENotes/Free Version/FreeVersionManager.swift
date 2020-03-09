//
//  FreeVersionManager.swift
//  ENotes
//
//  Created by Aleksey on 16/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class FreeVersionManager {
	
	enum NotificationType {
		case addNote
		case removeNote
		
		var notificationName: Notification.Name {
			switch self {
			case .addNote:
				return .addNote // Notification.Name(rawValue: "NoteAddedNotification")
			case .removeNote:
				return .removeNote // Notification.Name(rawValue: "NoteRemovedNotification")
			}
		}
	}
	
	private let numberOfFreeNotesLimit = 21
	private var currentNotesCount = 0
	
	/// Setup version type of software: full or free.
	init?() {
		#if FREE_VERSION
			startNotesLimitChecker()
		#else
			return nil
		#endif
	}
	
	private func startNotesLimitChecker() {
		print("startNotesLimitChecker()")
		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(forName: .addNote, object: nil, queue: .main) { _ in

			self.currentNotesCount += 1
			print("FREE VERSION: Add new note. Current count: \(self.currentNotesCount)")

			if self.currentNotesCount > self.numberOfFreeNotesLimit {
//				let appDelegate = UIApplication.shared.delegate
//				appDelegate?.window??.rootViewController?.present(EndFreeTrialViewController(), animated: true)
				
				let rootViewController = UIApplication.shared.keyWindow?.rootViewController
				rootViewController?.present(EndFreeTrialViewController(), animated: true)
			}
		}
		
		notificationCenter.addObserver(forName: .removeNote, object: nil, queue: .main) { _ in
			
			self.currentNotesCount -= 1
			print("FREE VERSION: Remove existing note. Current count: \(self.currentNotesCount)")
		}
	}
}


extension Notification.Name {
	static let addNote = Notification.Name(rawValue: "NoteAddedNotification")
	static let removeNote = Notification.Name(rawValue: "NoteRemovedNotification")
}
