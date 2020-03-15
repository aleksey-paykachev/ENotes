//
//  IndexPath + Extensions.swift
//  ENotes
//
//  Created by Aleksey on 15.03.2020.
//  Copyright © 2020 Aleksey Paykachev. All rights reserved.
//

import Foundation

extension Array where Element == IndexPath {

	/// All sections of the current indexPath array.
	var sections: [Int] {
		map { $0.section }
	}

	/// All items of the current indexPath array.
	var items: [Int] {
		map { $0.item }
	}
}
