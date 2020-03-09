//
//  TextNoteTableViewCell.swift
//  ENotes
//
//  Created by Aleksey on 18/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class TextNoteTableViewCell: UITableViewCell {
	
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
		contentWrapperView.layer.cornerRadius = Constants.noteCellCornerRadius
		contentWrapperView.layer.shadowColor = Constants.noteCellShadowColor
		contentWrapperView.layer.shadowOffset = Constants.noteCellShadowOffset
		contentWrapperView.layer.shadowRadius = Constants.noteCellShadowRadius
		contentWrapperView.layer.shadowOpacity = Constants.noteCellShadowOpacity
		
		//TextNote color circle setup
		colorView.layer.masksToBounds = true
		colorView.layer.cornerRadius = colorView.bounds.width / 2 //circle
		colorView.layer.borderColor = Constants.colorCircleBorderColor
		colorView.layer.borderWidth = Constants.colorCircleBorderWidth

		//TextNote color circle gradient setup
		let gradient = CAGradientLayer()
		gradient.colors = [
			Constants.colorCircleTopGradientColor,
			Constants.colorCircleBottomGradientColor]
		gradient.setDirection(.fromTopToBottom)
		gradient.frame = colorView.bounds
		colorView.layer.addSublayer(gradient)
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		let alpha = selected ? Constants.selectedStateAlpha : Constants.notSelectedStateAlpha
		contentWrapperView.backgroundColor = contentWrapperView.backgroundColor?.withAlphaComponent(alpha)
	}
	
	private struct Constants {
		// Note view
		static let noteCellCornerRadius: CGFloat = 5
		static let noteCellShadowColor = UIColor.lightGray.cgColor
		static let noteCellShadowOffset = CGSize(width: 0, height: 3)
		static let noteCellShadowRadius: CGFloat = 3
		static let noteCellShadowOpacity: Float = 0.4
		
		// Color circle
		static let colorCircleBorderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
		static let colorCircleBorderWidth: CGFloat = 1
		static let colorCircleTopGradientColor = UIColor.clear.cgColor
		static let colorCircleBottomGradientColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor

		// Note selection state
		static let selectedStateAlpha: CGFloat = 0.8
		static let notSelectedStateAlpha: CGFloat = 1
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
