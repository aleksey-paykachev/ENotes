//
//  LocalizedString.swift
//  ENotes
//
//  Created by Aleksey on 13.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

struct LocalizedString {
	// Base localization language is English.
	
	struct TextNotes {
		static let title = NSLocalizedString("Notes", comment: "Text notes list title. Shown both in navigation bar at the top and in the tab bar at the bottom.")
	}
	
	struct TextNote {
		static let formattedTextTemplate = NSLocalizedString("until %@", comment: "Shows user self destruction date of the note in following template format: 'until %date%'.")
		
		static func getFormattedDateText(for date: Date?) -> String? {
			guard let formattedDate = date?.shortFormatString else { return nil }

			return String.localizedStringWithFormat(formattedTextTemplate, formattedDate)
		}
	}
	
	struct TextNoteEditor {
		static let defaultTitle = NSLocalizedString("No title", comment: "Shows as a note title if user hasn't provide one while editing a note.")

		static let newNote = NSLocalizedString("New note", comment: "Shows in the navigation bar when user create a new note.")

		static let noteTitlePlaceholder = NSLocalizedString("Note title", comment: "Text label placeholder for a note title.")

		static let noteContentPlaceholder = NSLocalizedString("Note content", comment: "Text label placeholder for a note content.")

		static let removeAfterDate = NSLocalizedString("Remove after date", comment: "Self destruction date of a note. Shows in a label next to date picker.")
	}

	struct ColorPicker {
		static let cancelButton = NSLocalizedString("Cancel", comment: "Cancel action button text of the color picker.")
		
		static let saveButton = NSLocalizedString("Save", comment: "Save action button text of the color picker.")
	}
	
	struct PhotoNotes {
		static let title = NSLocalizedString("Photo Notes", comment: "Photo notes list title. Shown both in navigation bar at the top and in the tab bar at the bottom.")
	}
	
	struct ImageSourceSelector {
		static let title = NSLocalizedString("Please select the source of the photo note image.", comment: "Title of the image source selector. Asks user to choose source type of the photo note image.")
		static let cameraButton = NSLocalizedString("Camera", comment: "Camera action button text of the image source selector. Allows user to shoot an image from camera.")
		static let photoLibraryButton = NSLocalizedString("Photo library", comment: "Photo library action button text of the image source selector. Allows user to select an image from photo library.")
		static let cancelButton = NSLocalizedString("Cancel", comment: "Cancel action button text of the image source selector.")
	}
	
	struct EndFreeTrial {
		static let description = NSLocalizedString("Free trial limit has been reached.", comment: "Notifies the user that aplication's free trial has been ended.")
		
		static let askForMoneyTitle = NSLocalizedString("Where is the money?", comment: "Title of free trial ending notification.")
		
		static let askForMoneySubtitle = NSLocalizedString("Where is the money, Lebowski?", comment: "Subtitle of free trial ending notification. Politely asks the user for the money.")
	}
}
