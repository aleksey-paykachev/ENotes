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
	func registerCell(ofType cellType: UICollectionViewCell.Type) {
		register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
	}
	
	/// Returns a reusable cell object of given cell type located by identifier.
	/// - Parameters:
	///   - cellType: Type of the cell.
	///   - indexPath: The reuse identifier for the specified cell.
	///
	func dequeueCell<T: UICollectionViewCell>(ofType cellType: T.Type, for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
			
			fatalError("Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
		}

		return cell
	}
}
