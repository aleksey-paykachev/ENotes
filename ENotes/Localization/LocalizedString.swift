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

	struct ColorPicker {
		static let cancelButton = NSLocalizedString("Cancel", comment: "Cancel action button text of the color picker.")
		static let saveButton = NSLocalizedString("Save", comment: "Save action button text of the color picker.")
	}
}
