//
//  ExtendedTextView.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

// Simple implementation of textview placeholder for demo purposes only.
// Should not be used inside any real project because of its limitations: hardcoded text font and constraint, overriden delegate, and so on.

class ExtendedTextView: UITextView {
	
	/// Placeholder text.
	var placeholder: String? { didSet { updateUI() } }
	
	private var placeholderLabel: UILabel!

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		updateUI()
	}
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		updateUI()
	}

	private func updateUI() {
		if let placeholder = placeholder {
			placeholderLabel = UILabel()
			placeholderLabel.text = placeholder
			placeholderLabel.textColor = .lightGray
			placeholderLabel.sizeToFit()
			
			addSubview(placeholderLabel)
			placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
			placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
			placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true

			delegate = self
		} else {
			placeholderLabel = nil
			delegate = nil
		}
	}
}


// MARK: - self delegate

extension ExtendedTextView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		if placeholder != nil {
			placeholderLabel.isHidden = !textView.text.isEmpty
		}
	}
}
