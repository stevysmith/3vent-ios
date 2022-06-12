//
//  BaseViewController.swift
//  web3vent
//
//  Created by Alok Sahay on 12/06/2022.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func displayNetworkError() {
        displayError("Error", message: "bad Heroku bad :(")
    }
    
    func displayParseError() {
        displayError("Error", message: "Parsing issue, that's all we know")
    }
    
    func displayError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert.withCloseButton(), animated: true)
    }
}

extension UIAlertController {
    func withCloseButton() -> UIAlertController {
        addAction(UIAlertAction(title: "Close", style: .cancel))
        return self
    }

    static func showFailedToConnect(from controller: UIViewController) {
        let alert = UIAlertController(title: "Failed to connect", message: nil, preferredStyle: .alert)
        controller.present(alert.withCloseButton(), animated: true)
    }

    static func showDisconnected(from controller: UIViewController) {
        let alert = UIAlertController(title: "Did disconnect", message: nil, preferredStyle: .alert)
        controller.present(alert.withCloseButton(), animated: true)
    }
}
