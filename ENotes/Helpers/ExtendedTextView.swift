//
//  ExtendedTextView.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// TextView with a placeholder. Delegate property of UITextView should not be used because
/// current implementation of placeholder visibility handling relies on delegate internaly.
///
class ExtendedTextView: UITextView {
	
	/// Placeholder text.
	var placeholder: String? { didSet { setPlaceholderText() } }

	override var text: String! { didSet { updatePlaceholderVisibility() } }
	
	private let placeholderLabel = UILabel()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setup()
	}
	
	private func setup() {
		placeholderLabel.font = font
		placeholderLabel.textColor = .lightGray
		
		addSubview(placeholderLabel)
		placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding,
												y: textContainerInset.top)
		
		delegate = self
		updatePlaceholderVisibility()
	}

	private func setPlaceholderText() {
		placeholderLabel.text = placeholder
		placeholderLabel.sizeToFit()

		updatePlaceholderVisibility()
	}
	
	private func updatePlaceholderVisibility() {
		placeholderLabel.isHidden = placeholder == nil || text.isNotEmpty
	}
}


// MARK: - self delegate

extension ExtendedTextView: UITextViewDelegate {

	func textViewDidChange(_ textView: UITextView) {
		updatePlaceholderVisibility()
	}
}
