//
//  TextNoteEditorViewController.swift
//  ENotes
//
//  Created by Aleksey on 10/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol TextNoteEditorViewControllerDelegate: class {
	/// Notifies delegate that user did create new note
	func didCreateNew(_ note: TextNote)

	/// Notifies delegate that user did edit existed note
	func didEditExisting(_ note: TextNote)
}

/// Provides user interface for editing existing or creating a new text note.
class TextNoteEditorViewController: UIViewController {
	
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
	weak var delegate: TextNoteEditorViewControllerDelegate?

	private let colorSelectorViewController = ColorSelectorViewController()
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

		UIView.animate(withDuration: animated ? 0.5 : 0) {
			self.selfDestructionDateDatePickerContainerViewHeightConstraint.constant = isEnabled ? self.selfDestructionDateDatePicker.intrinsicContentSize.height : 0

			self.view.layoutIfNeeded()
		}
	}
	
	// Start observing keyboard notification to recalculate main scrollView insets
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self,
									   selector: #selector(keyboardWillShowOrHide),
									   name: UIResponder.keyboardWillShowNotification,
									   object: nil)
		notificationCenter.addObserver(self,
									   selector: #selector(keyboardWillShowOrHide),
									   name: UIResponder.keyboardWillHideNotification,
									   object: nil)
	}
	
	// Stop observing keyboard notification, and save note then "back" button was pressed
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		NotificationCenter.default.removeObserver(self)

		// "back" button was pressed
		if isMovingFromParent {
			saveNote()
		}
	}
}


// MARK: - setup

extension TextNoteEditorViewController {
	
	private func setupGeneral() {
		// navigation title
		let newNoteLocalizedText = NSLocalizedString("New note", comment: "Shows in the navigation bar when user create a new note.")
		title = mode == .createNew ? newNoteLocalizedText : note.title
		
		// set UILabel leading alignment relative to UITextView
		removeAfterDateTextLabelLeadingConstraint.constant = noteContentTextView.textContainer.lineFragmentPadding
		
		// set tap gesture to hide keyboard when user tap on empty space
		let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)
		
		// also dismiss keyboard on dragging down
		contentWraperScrollView.keyboardDismissMode = .interactive
	}
	
	private func setupTextInputs() {
		noteTitleTextField.placeholder = NSLocalizedString("Note name", comment: "Text label placeholder for a note name.")
		noteTitleTextField.delegate = self

		noteContentTextView.placeholder = NSLocalizedString("Note content", comment: "Text label placeholder for a note content.")
	}
	
	private func setupDatePicker() {
		removeAfterDateTextLabel.text = NSLocalizedString("Remove after date", comment: "Self destruction date of a note. Shows in a label next to date picker.")

		selfDestructionDateDatePickerContainerView.clipsToBounds = true
	}
	
	// Add color selector view controller as a child to the current view controller
	private func setupColorSelectorViewController() {
		colorSelectorViewController.willMove(toParent: self)
		addChild(colorSelectorViewController)

		let colorSelectorCollectionView = colorSelectorViewController.collectionView!
		stackView.addArrangedSubview(colorSelectorCollectionView)

		colorSelectorViewController.didMove(toParent: self)
	}
}


// MARK: - note methods

extension TextNoteEditorViewController {

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
		let content = noteContentTextView.text ?? ""

		// do not create empty text note (without title or content)
		guard title.isNotEmpty || content.isNotEmpty else { return }
		
		if title.isEmpty {
			title = NSLocalizedString("No title", comment: "Shows as a note title if user hasn't provide one while editing a note.")
		}

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

extension TextNoteEditorViewController {
	
	// Recalculate and update main scroll view insets on keyboard show/hide notifications.
	@objc private func keyboardWillShowOrHide(_ notification: Notification) {
		guard let keyboardInfo = KeyboardNotificationInfo(of: notification) else { return }

		let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
		let bottomInset = keyboardInfo.isShowing ? keyboardInfo.height - tabBarHeight : 0
		
		contentWraperScrollView.contentInset.bottom = bottomInset
		contentWraperScrollView.scrollIndicatorInsets.bottom = bottomInset
	}
}


// MARK: - noteTitleTextField delegate

extension TextNoteEditorViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// after finish entering title, move focus to edit note content
		noteContentTextView.becomeFirstResponder()
		return true
	}
}
