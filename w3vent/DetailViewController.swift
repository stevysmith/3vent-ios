//
//  DetailViewController.swift
//  w3vent
//
//  Created by Steve Smith on 11/06/2022.
//

import UIKit
import WalletConnectSwift

class DetailViewController: UIViewController {
    
    var client: Client!
    var session: Session!
    
    static func create(walletConnect: WalletConnect) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.client = walletConnect.client
        controller.session = walletConnect.session
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

