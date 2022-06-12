//
//  ContentManager.swift
//  web3vent
//
//  Created by Alok Sahay on 11/06/2022.
//

import Foundation
import WalletConnectSwift

class ContentManager {
    
    var walletConnectClient: WalletConnect?
    var user: UserProfile?
    static var shared = ContentManager()
    
    func startUserSession(wcClient: WalletConnect) -> Bool {
        walletConnectClient = wcClient
        self.user = UserProfile()
        
        guard let walletAddress = wcClient.session.walletInfo?.accounts[0] else {
            return false
        }
        
        self.user?.walletAddress = walletAddress
        return true
    }
    
    func closeSession() {
        
        guard let walletConnect = self.walletConnectClient, let client = walletConnect.client else {
            return
        }
        
        for session in walletConnect.client.openSessions() {
            try? client.disconnect(from: session)
        }

        walletConnectClient = nil
        user = nil
    }
}
