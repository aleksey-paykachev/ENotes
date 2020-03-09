//
//  TextNotesTableViewController.swift
//  ENotes
//
//  Created by Aleksey on 18/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class TextNotesTableViewController: UITableViewController {

	private let notebook: Notebook<TextNote>
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Initializes and returns table view controller displaying text notebook notes.
	///
	/// - Parameter notebook: Notebook which notes will be displayed in table view controller.
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
		let cellNib = UINib(nibName: TextNoteTableViewCell.className, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TextNoteTableViewCell.reuseIdentifier)

		tableView.allowsMultipleSelection = false
		tableView.separatorStyle = .none
		tableView.backgroundColor = Constants.textNotesListBackgroundColor
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
	
	private struct Constants {
		static let textNotesListBackgroundColor = UIColor(white: 0.95, alpha: 1)
	}
}


// MARK: - self data source

extension TextNotesTableViewController {
	
	// Data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notebook.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TextNoteTableViewCell.reuseIdentifier, for: indexPath) as! TextNoteTableViewCell
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

extension TextNotesTableViewController {
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let note = notebook.get(by: indexPath.row)
		showEditTextNoteViewController(note: note)
	}
}


// MARK: - EditTextNoteViewControllerDelegate

extension TextNotesTableViewController: EditTextNoteViewControllerDelegate {
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
