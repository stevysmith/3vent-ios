//
//  ViewController.swift
//  w3vent
//
//  Created by Steve Smith on 11/06/2022.
//

import UIKit

class MainViewController: UIViewController {
    var handshakeController: HandshakeViewController!
    var detailController: DetailViewController!
    var walletConnect: WalletConnect!

    @IBAction func connect(_ sender: Any) {
        let connectionUrl = walletConnect.connect()

        /// https://docs.walletconnect.org/mobile-linking#for-ios
        /// **NOTE**: Majority of wallets support universal links that you should normally use in production application
        /// Here deep link provided for integration with server test app only
        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"
        
        // depends what you want
        let rainbowUrl = URL(string: "https://rnbwapp.com/wc?uri=\(connectionUrl.addingPercentEncoding(withAllowedCharacters: .controlCharacters) ?? "")")
        let metamaskUrl = URL(string: "https://metamask.app.link/wc?uri=\(connectionUrl.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(rainbowUrl!) {
                UIApplication.shared.open(rainbowUrl!, options: [:], completionHandler: nil)
            } else {
                self.handshakeController = HandshakeViewController.create(code: connectionUrl)
                self.present(self.handshakeController, animated: true)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        walletConnect = WalletConnect(delegate: self)
        walletConnect.reconnectIfNeeded()
    }

    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}

extension MainViewController: WalletConnectDelegate {
    func failedToConnect() {
        onMainThread { [unowned self] in
            if let handshakeController = self.handshakeController {
                handshakeController.dismiss(animated: true)
            }
            UIAlertController.showFailedToConnect(from: self)
        }
    }

    func didConnect() {
        onMainThread { [unowned self] in
            self.detailController = DetailViewController.create(walletConnect: self.walletConnect)
            if let handshakeController = self.handshakeController {
                handshakeController.dismiss(animated: false) { [unowned self] in
                    self.present(self.detailController, animated: false)
                }
            } else if self.presentedViewController == nil {
                self.present(self.detailController, animated: false)
            }
        }
    }

    func didDisconnect() {
        onMainThread { [unowned self] in
            if let presented = self.presentedViewController {
                presented.dismiss(animated: false)
            }
            UIAlertController.showDisconnected(from: self)
        }
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

