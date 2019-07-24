//
//  String+Localization.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
