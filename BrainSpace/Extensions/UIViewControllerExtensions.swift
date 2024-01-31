//
//  UIViewControllerExtensions.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright © 2024 Kiran Sarvaiya. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String = Constants.AppTitle, message: String?, actions: [AlertAction] = [AlertAction(title: "Cancel", style: .cancel, handler: nil)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: action.handler)
            alert.addAction(alertAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

struct AlertAction {
    let title: String?
    let style: UIAlertAction.Style
    let handler: ((UIAlertAction) -> Void)?
}

struct Constants {
    static let AppTitle = "BrainSpace"
}
