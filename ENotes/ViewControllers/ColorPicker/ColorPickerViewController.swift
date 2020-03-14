//
//  ColorPickerViewController.swift
//  ENotes
//
//  Created by Aleksey on 11/07/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
	/// Notifies delegate that user did select custom color.
	func didSelectColor(_ color: HSBColor)
}

class ColorPickerViewController: UIViewController {
	
	@IBOutlet private var selectedColorView: SelectedColorView!
	@IBOutlet private var hueSaturationSelectionAreaView: HueSaturationSelectionAreaView!
	@IBOutlet private var brightnessSliderView: BrightnessSliderView!
	@IBOutlet private var cancelButton: UIButton!
	@IBOutlet private var saveButton: UIButton!
	
	/// Color picker delegate.
	weak var delegate: ColorPickerDelegate?

	private var color: HSBColor
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(color: HSBColor) {
		self.color = color
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
	}
	
	private func setup() {
		// handle situation when color picker presented as a sheet (not in full screen mode)
		presentationController?.delegate = self
	}
	
	private func setupSubviews() {
		// action buttons
		cancelButton.setTitle(LocalizedString.ColorPicker.cancelButton, for: .normal)
		saveButton.setTitle(LocalizedString.ColorPicker.saveButton, for: .normal)
		
		// color components selectors
		selectedColorView.set(color: color)
		hueSaturationSelectionAreaView.set(color: color)
		brightnessSliderView.set(color: color)
		
		brightnessSliderView.delegate = self
		hueSaturationSelectionAreaView.delegate = self
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


// MARK: - UIAdaptivePresentationControllerDelegate

extension ColorPickerViewController: UIAdaptivePresentationControllerDelegate {
	
	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		// treat manual dismiss as color selection
		delegate?.didSelectColor(color)
	}
}
