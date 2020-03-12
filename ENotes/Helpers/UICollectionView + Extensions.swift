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
}
