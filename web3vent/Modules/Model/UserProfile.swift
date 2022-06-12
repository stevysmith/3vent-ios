//
//  UserProfile.swift
//  web3vent
//
//  Created by Alok Sahay on 11/06/2022.
//

import Foundation
import UIKit
class UserProfile: NSObject {
    
    var walletAddress: String?
    var userName: String?
    var userBio: String?
    var userTwitter: String?
    var userTelegram: String?
    var userLinkedin: String?
    
    let userImage: UIImage? = {
        let imageNumber = Int.random(in: 0...5)
        let pfp = "ape" + "\(imageNumber)"
        return UIImage(named: pfp)
    }()
}
