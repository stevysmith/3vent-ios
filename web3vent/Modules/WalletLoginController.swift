//
//  ViewController.swift
//  web3vent
//
//  Created by Alok Sahay on 11/06/2022.
//

import UIKit
import AVKit

class WalletLoginController: BaseViewController {
    
    var playerLooper: NSObject?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var player: AVQueuePlayer?
        
    var eventListVc: DashboardViewController?
    var walletConnect: WalletConnect!
    var handshakeController: HandshakeViewController?
    
    @IBOutlet weak var buttonHolderView: UIView!
    @IBOutlet weak var playerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = buttonHolderView.bounds
        buttonHolderView.addSubview(blurredEffectView)
        buttonHolderView.layer.cornerRadius = 4
        buttonHolderView.clipsToBounds = true
        
        playVideo()

        walletConnect = WalletConnect(delegate: self)
        walletConnect.reconnectIfNeeded()
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let connectionUrl = walletConnect.connect()

        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"
        
        // depends what you want
        let rainbowUrl = URL(string: "https://rnbwapp.com/wc?uri=\(connectionUrl.addingPercentEncoding(withAllowedCharacters: .controlCharacters) ?? "")")
//        let metamaskUrl = URL(string: "https://metamask.app.link/wc?uri=\(connectionUrl.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")")
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(rainbowUrl!) {
                UIApplication.shared.open(rainbowUrl!, options: [:], completionHandler: nil)
            } else {
                self.handshakeController = HandshakeViewController.create(code: connectionUrl)
                guard let handShakeControllerInstance = self.handshakeController else {
                    print("Couldnt instantiate handshake")
                    return
                }
                self.present(handShakeControllerInstance, animated: true)
            }
        }
    }
    
    func gotoEventsList() {
        performSegue(withIdentifier: "gotoEvents", sender: nil)
    }
}

extension WalletLoginController {
    
    private func playVideo() {
        
        if let path = Bundle.main.path(forResource: "LandingVideo", ofType: "mp4") {
            let url =  URL(fileURLWithPath: path)
            
            let playerItem = AVPlayerItem(url: url as URL)
            self.player = AVQueuePlayer(items: [playerItem])
            self.playerLayer = AVPlayerLayer(player: self.player)

            guard let playerLayer = self.playerLayer, let player = self.player else {
                return
            }
            
            self.playerLooper = AVPlayerLooper(player: player , templateItem: playerItem)
            player.rate = 0.5
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerView.layer.insertSublayer(playerLayer, at: 0)
            self.playerLayer?.frame = playerView.frame
            self.player?.play()
        }
    }
}

extension WalletLoginController: WalletConnectDelegate {
    
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
            guard let client = self.walletConnect else {
                print("Didnt work")
                return
            }
            
            if ContentManager.shared.startUserSession(wcClient: client) == true {
               
                self.eventListVc = DashboardViewController()
                if let handshakeController = self.handshakeController {
                    handshakeController.dismiss(animated: false) { [unowned self] in
                        self.gotoEventsList()
                    }
                } else if self.presentedViewController == nil {
                    self.gotoEventsList()
                }
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
