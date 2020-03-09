//
//  ColorPickerViewController.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
	/// Notifies delegate that user did select a custom color
	func didSelectColor(_ color: HSBColor)
}

class ColorPickerViewController: UIViewController {
	
	@IBOutlet private var selectedColorView: SelectedColorView!
	@IBOutlet private var hueSaturationSelectionAreaView: HueSaturationSelectionAreaView!
	@IBOutlet private var brightnessSliderView: BrightnessSliderView!
	@IBOutlet private var cancelButton: UIButton!
	@IBOutlet private var saveButton: UIButton!

	weak var delegate: ColorPickerDelegate?

	private var color: HSBColor
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(color: HSBColor?) {
		self.color = color ?? .white
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		localizationSetup()
		
		brightnessSliderView.delegate = self
		hueSaturationSelectionAreaView.delegate = self
		
		selectedColorView.set(color: color)
		hueSaturationSelectionAreaView.set(color: color)
		brightnessSliderView.set(color: color)
	}
	
	private func localizationSetup() {
		let cancelButtonText = NSLocalizedString("Cancel", comment: "Cancel action button text of the color picker.")
		let saveButtonText = NSLocalizedString("Save", comment: "Save action button text of the color picker.")
		
		cancelButton.setTitle(cancelButtonText, for: .normal)
		saveButton.setTitle(saveButtonText, for: .normal)
	}
	
	@IBAction func cancelButtonDidPressed() {
		dismiss(animated: true)
	}
	
	@IBAction func saveButtonDidPressed() {
		delegate?.didSelectColor(color)
		dismiss(animated: true)
	}
}


// MARK: - BrightessSliderViewDelegate

extension ColorPickerViewController: BrightessSliderViewDelegate {

	func brightnessDidChanged(to brightness: CGFloat) {
		color.brightness = brightness

		selectedColorView.set(color: color)
		hueSaturationSelectionAreaView.set(color: color)
	}
}


// MARK: - HueSaturationSelectionAreaViewDelegate

extension ColorPickerViewController: HueSaturationSelectionAreaViewDelegate {

	func hueSaturationDidChanged(hue: CGFloat, saturation: CGFloat) {
		color.hue = hue
		color.saturation = saturation
		
		selectedColorView.set(color: color)
		brightnessSliderView.set(color: color)
	}
}
