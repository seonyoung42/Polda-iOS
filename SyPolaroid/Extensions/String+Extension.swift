//
//  String+Extension.swift
//  SyPolaroid
//
//  Created by 장선영 on 2022/03/30.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment:"")
    }
}
