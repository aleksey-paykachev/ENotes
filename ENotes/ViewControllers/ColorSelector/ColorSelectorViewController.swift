//
//  ColorSelectorViewController.swift
//  ENotes
//
//  Created by Aleksey on 16/08/2019.
//  Copyright © 2019 Aleksey Paykachev. All rights reserved.
//

import UIKit

/// Provides user interface for selection of the color.
class ColorSelectorViewController: UICollectionViewController {
	
	private let standardColors = [HSBColor.yellow, .green, .cyan, .magenta, .red]
	private var customColor = TextNote.defaultColor
	private var colors: [HSBColor] { standardColors + [customColor] }
	
	private let flowLayout = UICollectionViewFlowLayout()
	
	/// Currently selected color (standard or custom) or nil if no color were selected.
	var selectedColor: HSBColor? {
		guard let index = collectionView.firstSelectedItemIndex else { return nil }
		
		return colors[index]
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init() {
		super.init(collectionViewLayout: flowLayout)
	}
	
	/// Set color as selected.
	/// - Parameter color: Setted color in HSB format.
	///
	func setColor(_ color: HSBColor) {
		// if setted color is one of the standard, select corresponding color cell
		if let index = standardColors.firstIndex(of: color) {
			let indexPath = IndexPath(item: index, section: 0)
			collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
			return
		}

		// if setted color isn't standard, select custom color cell instead
		selectCustomColorCell(color: color)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	private func setup() {
		// setup collection view
		collectionView.backgroundColor = .clear
		collectionView.allowsMultipleSelection = false

		// setup collection view flow layout
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = .square(50)

		// set height of the collection view equal to single cell height (one row)
		collectionView.heightAnchor.constraint(equalToConstant: flowLayout.itemSize.height).isActive = true
		
		// register two type of cells: for standard colors and for custom one
		collectionView.registerCell(ColorSelectorCell.self)
		collectionView.registerCell(CustomColorSelectorCell.self)
	}
	
	private func selectCustomColorCell(color: HSBColor) {
		customColor = color
		
		// custom color cell is the last one (comes after all standard color cells)
		let indexPath = IndexPath(item: standardColors.endIndex, section: 0)
		collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)

		if let cell = collectionView.cellForItem(at: indexPath) as? CustomColorSelectorCell {
			cell.set(color)
		}
	}
}


// MARK: - self dataSource

extension ColorSelectorViewController {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		colors.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// standard color selector cell
		if indexPath.item < standardColors.endIndex {
			let cell = collectionView.dequeueCell(ColorSelectorCell.self, for: indexPath)
			cell.set(standardColors[indexPath.item])
			return cell

		}
		
		// custom color selector cell
		let cell = collectionView.dequeueCell(CustomColorSelectorCell.self, for: indexPath)
		cell.set(customColor)
		cell.delegate = self
		return cell
	}
}


// MARK: - CustomColorSelectorCellDelegate

extension ColorSelectorViewController: CustomColorSelectorCellDelegate {

	func customColorCellDidRecieveLongPress() {
		// show color picker, so user can select any custom color
		let colorPickerViewController = ColorPickerViewController(color: customColor)
		colorPickerViewController.delegate = self
		present(colorPickerViewController, animated: true, completion: nil)
	}
}


// MARK: - ColorPickerDelegate

extension ColorSelectorViewController: ColorPickerDelegate {

	func didSelectColor(_ color: HSBColor) {
		selectCustomColorCell(color: color)
	}
}
