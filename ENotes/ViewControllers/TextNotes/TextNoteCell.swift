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
		
		selectionStyle = .none
		
		//Background content wrapper setup
		contentWrapperView.layer.cornerRadius = 5
		contentWrapperView.layer.shadowColor = UIColor.lightGray.cgColor
		contentWrapperView.layer.shadowOffset = CGSize(width: 0, height: 3)
		contentWrapperView.layer.shadowRadius = 3
		contentWrapperView.layer.shadowOpacity = 0.4

		//TextNote color circle setup
		colorView.layer.masksToBounds = true
		colorView.layer.cornerRadius = colorView.bounds.width / 2 //circle
		colorView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
		colorView.layer.borderWidth = 1
		
		//TextNote color circle gradient setup
		let gradient = CAGradientLayer()
		gradient.colors = [
			UIColor.clear.cgColor,
			UIColor.darkGray.withAlphaComponent(0.3).cgColor]
		gradient.setDirection(.fromTopToBottom)
		gradient.frame = colorView.bounds
		colorView.layer.addSublayer(gradient)
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
		
		if let date = note.selfDestructionDate {
			let formattedText = NSLocalizedString("until %@", comment: "Shows user self destruction date of the note in format: 'until %date%'.")
			selfDestructionDateLabel.text = .localizedStringWithFormat(formattedText, date.shortFormatString)
		} else {
			selfDestructionDateLabel.text = ""
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		titleLabel.text = ""
		contentLabel.text = ""
		colorView.backgroundColor = nil
		selfDestructionDateLabel.text = ""
	}
}
