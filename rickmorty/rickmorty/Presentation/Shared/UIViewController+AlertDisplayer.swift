//
//  UIViewController+AlertDisplayer.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(error: Error) {
        show(title: nil, message: error.localizedDescription, onClose: nil)
    }

    func show(title: String?, message: String?, onClose: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            onClose?()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
