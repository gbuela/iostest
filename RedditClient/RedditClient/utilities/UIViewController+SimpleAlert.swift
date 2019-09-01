//
//  UIViewController+SimpleAlert.swift
//  RedditClient
//
//  Created by German Buela on 01/09/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import UIKit

extension UIViewController {
    func simpleAlert(text: String) {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
