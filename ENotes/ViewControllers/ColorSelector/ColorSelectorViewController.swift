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
	
	private let standardColors = [UIColor.yellow, .green, .cyan, .magenta, .red]
	private var selectedCustomColor: HSBColor?
	
	/// Currently selected color of the color selector (standard or custom).
	/// If no color were selected, returns nil.
	var selectedColor: HSBColor? {
		guard let selectedIndex = collectionView.indexPathsForSelectedItems?.first?.item else { return nil }
		
		// standard color
		if selectedIndex < standardColors.count {
			return standardColors[selectedIndex].hsbColor
		}
		
		// custom color
		return selectedCustomColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init() {
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	/// Set one of the color selector collection view cell as selected. If setted color
	/// is one of the standard colors, select it, otherwise - select custom color cell.
	///
	/// - Parameter color: Setted color in custom HSB format.
	///
	func setColor(_ color: HSBColor) {
		// if setted color is one of the standard colors, select corresponding color cell
		for (index, standardColor) in standardColors.enumerated() {
			if color.uiColor == standardColor {
				let indexPath = IndexPath(item: index, section: 0)
				collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
				return
			}
		}
		
		// if setted color isn't a standard color, select a custom color cell instead
		selectCustomColor(color: color)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// setup collection view
		collectionView.backgroundColor = .white
		collectionView.allowsMultipleSelection = false

		// setup collection view flow layout
		let colorSelectorLayout = collectionViewLayout as! UICollectionViewFlowLayout
		colorSelectorLayout.scrollDirection = .horizontal
		colorSelectorLayout.itemSize = .square(50)

		// set height of the collection view equal to single cell height (one row)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.heightAnchor.constraint(equalToConstant: colorSelectorLayout.itemSize.height).isActive = true
		
		// register two type of cells: for standard colors and for custom one
		collectionView.registerCell(ofType: ColorSelectorCell.self)
		collectionView.registerCell(ofType: CustomColorSelectorCell.self)
	}
	
	private func selectCustomColor(color: HSBColor) {
		selectedCustomColor = color

		// custom color cell is the last one (comes after all standard color cells)
		let indexPath = IndexPath(item: standardColors.count, section: 0)
		collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)

		if let cell = collectionView.cellForItem(at: indexPath) as? CustomColorSelectorCell {
			cell.set(selectedCustomColor?.uiColor)
		}
	}
}


// MARK: - self dataSource

extension ColorSelectorViewController {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return standardColors.count + 1 //standard colors + custom color
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		// standard color selector cell
		if indexPath.item < standardColors.count {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSelectorCell.reuseIdentifier, for: indexPath) as! ColorSelectorCell
			cell.set(standardColors[indexPath.item])
			return cell
		}
		
		// custom color selector cell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomColorSelectorCell.reuseIdentifier, for: indexPath) as! CustomColorSelectorCell
		cell.set(selectedCustomColor?.uiColor)
		cell.delegate = self
		return cell
	}
}


// MARK: - colorSelectorCell delegate

extension ColorSelectorViewController: CustomColorSelectorCellDelegate {
	func colorSelectorCellDidAskForColorPicker() {

		// show color picker, so user can select any custom color
		let colorPickerViewController = ColorPickerViewController(color: selectedCustomColor)
		colorPickerViewController.delegate = self
		present(colorPickerViewController, animated: true, completion: nil)
	}
}


// MARK: - ColorPickerProtocol

extension ColorSelectorViewController: ColorPickerDelegate {
	func didSelectColor(_ color: HSBColor) {
		selectCustomColor(color: color)
	}
}
