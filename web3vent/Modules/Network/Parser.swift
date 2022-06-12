//
//  Parser.swift
//  web3vent
//
//  Created by Alok Sahay on 11/06/2022.
//

import Foundation

class Parser {
    
    static func parseProfile(jsonData: Data) -> UserProfile? {
        
        if let dict = NetworkManager.dataToDictionary(data: jsonData as NSData), let userDict = dict["profile"] {
            
            let user = UserProfile()
            user.userName = userDict["name"] as? String ?? ""
            user.userBio = userDict["bio"] as? String ?? ""
            user.userTwitter = userDict["twitter"] as? String ?? ""
            user.userLinkedin = userDict["telegram"] as? String ?? ""
            user.userTelegram = userDict["linkedin"] as? String ?? ""
            return user
        } else {
            return nil
        }
    }
    
    
    static func parseAttendees(jsonData: Data) -> [UserProfile] {
        var fetchedAttendees: [UserProfile] = []
        
        if let attendeesDict = NetworkManager.dataToDictionary(data: jsonData as NSData) {
            if let attendeesArr = attendeesDict["profiles"] as? [[String: Any]] {
                
                for attendee in attendeesArr {
                   
                    let user = UserProfile()
                    user.userName = attendee["name"] as? String ?? ""
                    user.userBio = attendee["bio"] as? String ?? ""
                    user.walletAddress = attendee["wallet"] as? String ?? ""
                    user.userTwitter = attendee["twitter"] as? String ?? ""
                    user.userLinkedin = attendee["telegram"] as? String ?? ""
                    user.userTelegram = attendee["linkedin"] as? String ?? ""
                    
                    fetchedAttendees.append(user)
                }
            }
        }
        return fetchedAttendees
    }
}

extension NetworkManager {
    
    static func dataToDictionary(data: NSData) -> [String: AnyObject]? {
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
            if let dictionary = dictionary as? [String:AnyObject] {
                return dictionary
            }
        } catch let error {
            let str = String(decoding: data, as: UTF8.self)
            print(error, " || " , str)
        }
        
        return nil
    }
    
    static func dataToArray(data: NSData) -> [AnyObject]? {
        
        do {
            let array = try (JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)) as AnyObject
            if array is [AnyObject] {
                return array as? [AnyObject]
            }
        } catch let error {
            let str = String(decoding: data, as: UTF8.self)
            print(error, " || " , str)
        }
        
        return nil
    }
}
