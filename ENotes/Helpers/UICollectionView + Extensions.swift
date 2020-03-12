//
//  UICollectionView + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 12.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import UIKit

extension UICollectionView {

	/// Register a class for use in creating new collection view cells.
	/// - Parameter cellType: Type of registered cell.
	///
	func registerCell(_ cellType: UICollectionViewCell.Type) {
		register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
	}
	
	/// Returns a reusable cell object of given cell type located by identifier.
	/// - Parameters:
	///   - cellType: Type of the cell.
	///   - indexPath: The reuse identifier for the specified cell.
	///
	func dequeueCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
			
			fatalError("Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
		}

		return cell
	}
	
	/// Index of first selected item of collection view or nil if were is no selected item.
	var firstSelectedItemIndex: Int? {
		indexPathsForSelectedItems?.first?.item
	}
}
