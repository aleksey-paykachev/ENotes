//
//  EditTextNoteViewController.swift
//  ENotes
//
//  Created by Aleksey on 10/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol EditTextNoteViewControllerDelegate: class {
	/// Notifies delegate that user did create new note
	func didCreateNew(_ note: TextNote)

	/// Notifies delegate that user did edit existed note
	func didEditExisting(_ note: TextNote)
}

/// Provides user interface for editing existing or creating a new text note.
class EditTextNoteViewController: UIViewController {
	
	private enum Mode {
		case createNew
		case editExisting
	}
	
	@IBOutlet private var stackView: UIStackView!
	@IBOutlet private var contentWraperScrollView: UIScrollView!
	@IBOutlet private var noteTitleTextField: UITextField!
	@IBOutlet private var noteContentTextView: ExtendedTextView!
	@IBOutlet private var removeAfterDateTextLabel: UILabel!
	@IBOutlet private var removeAfterDateTextLabelLeadingConstraint: NSLayoutConstraint!
	@IBOutlet private var selfDestructionDateDatePicker: UIDatePicker!
	@IBOutlet private var selfDestructionDateDatePickerSwitch: UISwitch!
	@IBOutlet private var selfDestructionDateDatePickerContainerView: UIView!
	@IBOutlet private var selfDestructionDateDatePickerContainerViewHeightConstraint: NSLayoutConstraint!
	
	/// Delegate to notify of note data modification
	weak var delegate: EditTextNoteViewControllerDelegate?

	private let colorSelectorViewController = ColorSelectorCollectionViewController()
	private let mode: Mode
	private var note: TextNote

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Returns view controller for editing a note.
	///
	/// - Parameter note: Text note to edit. If no note was provided (nil), create a new one.
	///
	init(note: TextNote?) {
		mode = note == nil ? .createNew : .editExisting
		self.note = note ?? .empty
		
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupGeneral()
		setupTextInputs()
		setupDatePicker()
		setupColorSelectorViewController()
		
		populateNote()
	}
	
	@IBAction private func selfDestructionDateSwitchPressed(_ sender: UISwitch) {
		setDatePicker(isEnabled: sender.isOn, animated: true)
	}
	
	// Activate (show) or deactivate (hide) date picker by changing its height constraint.
	private func setDatePicker(isEnabled: Bool, animated: Bool = false) {
		let animationDuration = animated ? Constants.datePickerShowHideAnimationDuration : 0

		UIView.animate(withDuration: animationDuration) {
			self.selfDestructionDateDatePickerContainerViewHeightConstraint.constant = isEnabled ? self.selfDestructionDateDatePicker.intrinsicContentSize.height : 0

			self.view.layoutIfNeeded()
		}
	}
	
	// Start observing keyboard notification to recalculate main scroll view insets
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self,
									   selector: #selector(keyboardWillShowOrHide(_:)),
									   name: UIResponder.keyboardWillShowNotification,
									   object: nil)
		notificationCenter.addObserver(self,
									   selector: #selector(keyboardWillShowOrHide(_:)),
									   name: UIResponder.keyboardWillHideNotification,
									   object: nil)
	}
	
	// Stop observing keyboard notification, and save note then "back" button was pressed
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NotificationCenter.default.removeObserver(self)

		// "Back" button was pressed
		if isMovingFromParent {
			saveNote()
		}
	}
	
	private struct Constants {
		static let datePickerShowHideAnimationDuration: TimeInterval = 0.5
	}
}


// MARK: - setup

extension EditTextNoteViewController {
	
	private func setupGeneral() {
		// Navigation title
		let newNoteLocalizedText = NSLocalizedString("New note", comment: "Shows in the navigation bar when user create a new note.")
		title = mode == .createNew ? newNoteLocalizedText : note.title
		
		// Set UILabel leading alignment relative to UITextView
		removeAfterDateTextLabelLeadingConstraint.constant = noteContentTextView.textContainer.lineFragmentPadding
		
		// Set tap gesture to hide keyboard when user tap on empty space
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)
	}
	
	private func setupTextInputs() {
//		let noteTitlePlaceholderLocalizedText = NSLocalizedString("Note name", comment: "Text label placeholder for a note name.")
//		let noteContentPlaceholderLocalizedText = NSLocalizedString("Note content", comment: "Text label placeholder for a note content.")

		noteTitleTextField.placeholder = NSLocalizedString("Note name", comment: "Text label placeholder for a note name.")
		noteTitleTextField.delegate = self

		noteContentTextView.placeholder = NSLocalizedString("Note content", comment: "Text label placeholder for a note content.")
		//note.content.isEmpty ? noteContentPlaceholderLocalizedText : nil
	}
	
	private func setupDatePicker() {
		removeAfterDateTextLabel.text = NSLocalizedString("Remove after date", comment: "Self destruction date of a note. Shows in a label next to date picker.")

//		setDatePicker(isEnabled: note.selfDestructionDate != nil)
		selfDestructionDateDatePickerContainerView.clipsToBounds = true
	}
	
	private func setupColorSelectorViewController() {
		// Set color selector view controller as a child of current view controller, and move its view into stack

		colorSelectorViewController.willMove(toParent: self)
		addChild(colorSelectorViewController)

		let collectionView = colorSelectorViewController.collectionView!
		stackView.addArrangedSubview(collectionView)

		colorSelectorViewController.didMove(toParent: self)
	}
}


// MARK: - note methods

extension EditTextNoteViewController {

	// Update all UI elements with note data
	private func populateNote() {
		noteTitleTextField.text = note.title
		noteContentTextView.text = note.content
		
		selfDestructionDateDatePickerSwitch.isOn = note.selfDestructionDate != nil
		selfDestructionDateDatePicker.date = note.selfDestructionDate ?? Date()
		setDatePicker(isEnabled: selfDestructionDateDatePickerSwitch.isOn)
		
		if mode == .editExisting {
			colorSelectorViewController.setColor(note.color)
		}
	}
	
	private func saveNote() {
		var title = noteTitleTextField.text ?? ""
		if title.isEmpty {
			title = NSLocalizedString("No title", comment: "Shows as a note title if user hasn't provide one while editing a note.")
		}

		let content = noteContentTextView.text ?? ""
		let color = colorSelectorViewController.selectedColor
		let selfDestructionDate = selfDestructionDateDatePickerSwitch.isOn ? selfDestructionDateDatePicker.date : nil
		
		note = TextNote(uid: note.uid, title: title, content: content, color: color, selfDestructionDate: selfDestructionDate)
		
		switch mode {
		case .createNew:
			delegate?.didCreateNew(note)
		case .editExisting:
			delegate?.didEditExisting(note)
		}
	}
}


// MARK: - keyboard

extension EditTextNoteViewController {
	
	// Recalculate and update main scroll view position then keyboard are being shown or hidden. This function calls by notification.
	@objc private func keyboardWillShowOrHide(_ notification: Notification) {
		guard let userInfo = notification.userInfo, let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
		
		let isKeyboardShown = notification.name == UIResponder.keyboardWillShowNotification
		let bottomInset = isKeyboardShown ? frameEnd.height : 0
		
		contentWraperScrollView.contentInset.bottom = bottomInset
		contentWraperScrollView.scrollIndicatorInsets.bottom = bottomInset
	}
	
	@objc private func hideKeyboard() {
		view.endEditing(true)
	}
}


// MARK: - noteTitleTextField delegate

extension EditTextNoteViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
