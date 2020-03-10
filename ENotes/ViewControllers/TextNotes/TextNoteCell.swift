//
//  TextNoteCell.swift
//  ENotes
//
//  Created by Aleksey on 18/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class TextNoteCell: UITableViewCell {
	
	/// Text note to display in current cell.
	var note: TextNote? { didSet { updateUI() } }
	
	@IBOutlet private var contentWrapperView: UIView!
	@IBOutlet private var colorView: UIView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var contentLabel: UILabel!
	@IBOutlet private var selfDestructionDateLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupCell()
	}
	
	private func setupCell() {
		selectionStyle = .none
		
		// background content wrapper
		contentWrapperView.layer.setRadius(5, maskToBounds: false)
		contentWrapperView.layer.setShadow(radius: 3, color: .lightGray, offsetY: 3, alpha: 0.4)

		// textNote color circle
		colorView.layer.setRadius(colorView.bounds.width / 2) //circle
		colorView.layer.setBorder(width: 1, color: .lightGray, alpha: 0.5)
		colorView.layer.setGradient(direction: .fromTopToBottom,
									colors: [.clear, UIColor.darkGray.withAlphaComponent(0.3)])

	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		let alpha: CGFloat = selected ? 0.8 : 1
		contentWrapperView.backgroundColor += alpha
	}
	
	private func updateUI() {
		guard let note = note else { return }

		titleLabel.text = note.title
		contentLabel.text = note.content
		colorView.backgroundColor = note.color.uiColor
		selfDestructionDateLabel.text = getLocalizedDateText(for: note.selfDestructionDate)
	}
	
	private func getLocalizedDateText(for date: Date?) -> String? {
		guard let formattedDate = date?.shortFormatString else { return nil }
		
		let formattedText = NSLocalizedString("until %@", comment: "Shows user self destruction date of the note in format: 'until %date%'.")

		return String.localizedStringWithFormat(formattedText, formattedDate)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		titleLabel.text = ""
		contentLabel.text = ""
		colorView.backgroundColor = nil
		selfDestructionDateLabel.text = ""
	}
}
