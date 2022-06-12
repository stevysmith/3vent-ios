//
//  EventListViewController.swift
//  web3vent
//
//  Created by Alok Sahay on 11/06/2022.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet var attendeesPfpImageViews: [UIImageView]!
    @IBOutlet var attendeesBioLabels: [UILabel]!
    @IBOutlet var attendeeNameLabels: [UILabel]!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var attendeesData: [UserProfile]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.clipsToBounds = true
        fetchAttendees()
    }
    
    @IBAction func showOwnerProfile(_ sender: Any) {
        
        return //user profile not yet implemented
        
        guard let user = ContentManager.shared.user else {
            return
        }
                
        loadDetailPage(user)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        let senderTag = sender.tag
        if let attendeeProfile = attendeesData?[senderTag] {
            loadDetailPage(attendeeProfile)
        }
    }
    
    @IBAction func disconnect(_ sender: Any) {
        ContentManager.shared.closeSession()
    }
    
    @IBAction func close(_ sender: Any) {
        ContentManager.shared.closeSession()
        dismiss(animated: true)
    }
}

extension DashboardViewController {
    
    func fetchAttendees() {
        
        activityIndicatorView.startAnimating()
        
        NetworkManager.fetchParticipants {[weak self] (result, error) in
            
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
            }
            
            if error == nil {
                if let attendeesList = result {
                    DispatchQueue.main.async {
                        self?.loadAttendees(attendeesList)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.displayParseError()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.displayNetworkError()
                }
            }
        }
    }
    
    func loadAttendees(_ attendees: [UserProfile]) {
        
        attendeesData = attendees
        
        for (itemIndex, attendee) in attendees.enumerated() {
            if itemIndex < attendeeNameLabels.count {
                
                if let filteredLabel = attendeeNameLabels.filter({($0.tag == itemIndex)}).first {
                    filteredLabel.text = attendee.userName
                }
                
                if let bioLabel = attendeesBioLabels.filter({($0.tag == itemIndex)}).first {
                    bioLabel.text = attendee.userBio
                    bioLabel.textColor = .darkGray
                }
                
                if let pfpImageView = attendeesPfpImageViews.filter({($0.tag == itemIndex)}).first {
                    pfpImageView.layer.cornerRadius = pfpImageView.bounds.height/2
                    pfpImageView.image = attendee.userImage
                }
            }
        }
    }
    
    func loadDetailPage(_ user: UserProfile) {
        performSegue(withIdentifier: "showDetail", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? ProfileDetailViewController, let arg = sender as? UserProfile {
            
            let isOwnProfile = (arg.walletAddress == ContentManager.shared.user?.walletAddress)
            destinationVC.userProfile = arg
            destinationVC.isSelfProfile = isOwnProfile
        }
    }
}
