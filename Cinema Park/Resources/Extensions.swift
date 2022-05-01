//
//  Extensions.swift
//  Cinema Park
//
//  Created by Pavel Andreev on 4/21/22.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
