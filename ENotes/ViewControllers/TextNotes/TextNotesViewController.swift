//
//  TextNotesViewController.swift
//  ENotes
//
//  Created by Aleksey on 18/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class TextNotesViewController: UITableViewController {

	private let notebook: Notebook<TextNote>
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Initializes and returns view controller displaying text notebook notes.
	///
	/// - Parameter notebook: Text notebook which notes will be displayed.
	///
	init(notebook: Notebook<TextNote>) {
		self.notebook = notebook
		super.init(nibName: nil, bundle: nil)
		
		title = NSLocalizedString("Notes", comment: "Text notes list title. Shown both in navigation bar at the top and in the tab bar at the bottom.")
		tabBarItem.image = UIImage(named: "tabbar-icon-textnotes")
	}

    override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationItem()
		setupTableView()
	}
	
	private func setupNavigationItem() {
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteButtonDidPressed))
	}
	
	private func setupTableView() {
		let cellNib = UINib(nibName: TextNoteCell.className, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TextNoteCell.reuseIdentifier)

		tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
		tableView.allowsMultipleSelection = false
		tableView.separatorStyle = .none
	}
	
	@objc private func addNoteButtonDidPressed() {
		showEditTextNoteViewController()
	}
	
	private func showEditTextNoteViewController(note: TextNote? = nil) {
		let editTextNoteViewController = EditTextNoteViewController(note: note)
		editTextNoteViewController.delegate = self
		navigationController?.pushViewController(editTextNoteViewController, animated: true)
	}

	private func insertNewEntry() {
		guard notebook.count > 0 else { return }
	
		let lastIndexPath = IndexPath(row: notebook.count - 1, section: 0)

		tableView.insertRows(at: [lastIndexPath], with: .automatic)
		tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
	}
	
	private func updateEntry(at index: Int) {
		guard notebook.count > index else { return }

		let indexPath = IndexPath(row: index, section: 0)
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
}


// MARK: - self data source

extension TextNotesViewController {
	
	// Data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		notebook.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: TextNoteCell.reuseIdentifier, for: indexPath) as! TextNoteCell
		cell.note = notebook.get(by: indexPath.row)
		
		return cell
	}
	
	// Reordering
	
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		notebook.moveNoteByIndex(from: fromIndexPath.row, to: to.row)
	}
	
	// Deletion
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == .delete {
			notebook.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}


// MARK: - self delegate

extension TextNotesViewController {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let note = notebook.get(by: indexPath.row)
		showEditTextNoteViewController(note: note)
	}
}


// MARK: - EditTextNoteViewControllerDelegate

extension TextNotesViewController: EditTextNoteViewControllerDelegate {

	func didCreateNew(_ note: TextNote) {
		notebook.add(note)
		insertNewEntry()
	}
	
	func didEditExisting(_ note: TextNote) {
		guard let noteIndex = notebook.getIndex(by: note) else { return }

		notebook.update(note)
		updateEntry(at: noteIndex)
	}
}
