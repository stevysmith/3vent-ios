//
//  NetworkManager.swift
//  web3vent
//
//  Created by Alok Sahay on 11/06/2022.
//

import Foundation

class NetworkManager {
    
    static func getEventsUrl() -> URL {
        URL(string: "https://ev3nt-api.herokuapp.com/getAllProfiles")!
    }
    
    static func getProfileUrl(address: String) -> URL {
        URL(string: "https://ev3nt-api.herokuapp.com/getProfile/" + address)!
    }
        
    static func getUserProfile(address: String, completionHandler: @escaping ((_ result: UserProfile?, _ error: NSError?) -> Void)) {
        
        NetworkManager.fetchData(fromURL: NetworkManager.getProfileUrl(address: address)) { result in
            switch result {
            case .success(let data):
                if let profile = Parser.parseProfile(jsonData: data) {
                    completionHandler(profile, nil)
                } else {
                    print("Parse error")
                    completionHandler(nil, NSError())
                }
                
            case .failure(let error):
                print(error)
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    static func fetchParticipants(completionHandler: @escaping ((_ result: [UserProfile]?, _ error: NSError?) -> Void)) {
        
        NetworkManager.fetchData(fromURL: NetworkManager.getEventsUrl()) { result in
            switch result {
            case .success(let data):
                let attendees = Parser.parseAttendees(jsonData: data)
                completionHandler(attendees,nil)
            case .failure(let error):
                print(error)
                completionHandler(nil, error as NSError)
            }
        }
    }
    
}

extension NetworkManager {
    
    static func fetchData(fromURL url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        urlSession.resume()
    }
    
}
