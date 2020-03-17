//
//  EndOfFreeTrialViewController.swift
//  ENotes
//
//  Created by Aleksey on 07/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

class EndOfFreeTrialViewController: UIViewController {
	
	@IBOutlet private var freeTrialEndedDescriptionLabel: UILabel!
	@IBOutlet private var askForMoneyTitleLabel: UILabel!
	@IBOutlet private var askForMoneySubtitleLabel: UILabel!

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		freeTrialEndedDescriptionLabel.text = LocalizedString.EndOfFreeTrial.description
		askForMoneyTitleLabel.text = LocalizedString.EndOfFreeTrial.askForMoneyTitle
		askForMoneySubtitleLabel.text = LocalizedString.EndOfFreeTrial.askForMoneySubtitle
    }
}
