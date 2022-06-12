//
//  ProfileDetailViewController.swift
//  web3vent
//
//  Created by Alok Sahay on 12/06/2022.
//

import Foundation
import UIKit

class ProfileDetailViewController: BaseViewController {
    
    @IBOutlet weak var pfpImageView: UIImageView!
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var socialButtons: [UIButton]!
    
    var isSelfProfile: Bool = false //is profile of owner
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pfpImageView.image = isSelfProfile ? UIImage(named: "Pfp") : nil
        pfpImageView.backgroundColor = .lightGray
        profileLabel.text = isSelfProfile ? "My profile" : "View Profile"
        
        for label in [userNameLabel, userBioLabel] {
            label?.text = ""
        }
        
        for button in socialButtons {
            button.layer.cornerRadius = button.bounds.width/2
            button.clipsToBounds = true
        }
        
        
//        userSocialLabel1.link = userProfile?.userTwitter
//        userSocialLabel2.link = userProfile?.userLinkedin
//        userSocialLabel3.link = userProfile?.userTelegram
        
        pfpImageView.layer.cornerRadius = pfpImageView.bounds.width/2
        qrButton.layer.borderColor = UIColor.gray.cgColor
        qrButton.layer.borderWidth = 1.0
        
        fetchUserProfile()
    }
    
    func refreshProfile() {
        userNameLabel.text = userProfile?.userName //TODO
        userBioLabel.text = userProfile?.userBio
        pfpImageView.image = userProfile?.userImage
    }
    
    func fetchUserProfile() {
        activityIndicatorView.startAnimating()
        guard let userWallet = userProfile?.walletAddress else {
            return
        }
        
        NetworkManager.getUserProfile(address: userWallet) {[unowned self] result, error in
            
            self.onMainThread {
                self.activityIndicatorView.stopAnimating()
                if error == nil {
                    if let profile = result {
                        self.userProfile = profile
                        self.refreshProfile()
                    } else {
                        self.displayParseError()
                    }
                } else {
                    self.displayNetworkError()
                }
            }
        }
    }
    
    
    @IBAction func qrButtonPressed(_ sender: Any) {
        print("Show qr")
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
        
}
