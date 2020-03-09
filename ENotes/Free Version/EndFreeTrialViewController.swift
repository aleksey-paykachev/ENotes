//
//  EndFreeTrialViewController.swift
//  ENotes
//
//  Created by Aleksey on 07/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class EndFreeTrialViewController: UIViewController {
	
	@IBOutlet private var freeTrialEndedDescriptionLabel: UILabel!
	@IBOutlet private var askForMoneyTitleLabel: UILabel!
	@IBOutlet private var askForMoneySubtitleLabel: UILabel!

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		freeTrialEndedDescriptionLabel.text = NSLocalizedString("Free trial limit has been reached.", comment: "Notifies the user that aplication's free trial has been ended.")
		askForMoneyTitleLabel.text = NSLocalizedString("Where is the money?", comment: "Title of free trial ending notification.")
		askForMoneySubtitleLabel.text = NSLocalizedString("Where is the money, Lebowski?", comment: "Subtitle of free trial ending notification. Politely asks the user for the money.")
    }
}
