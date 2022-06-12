//
//  NibLoadable.swift
//  web3vent
//
//  Created by Alok Sahay on 11/06/2022.
//

import UIKit

protocol NibLoadable {
}

extension NibLoadable {
    static var defaultNibName: String {
        String(describing: self)
    }
    static var nib: UINib? {
        UINib(nibName: defaultNibName, bundle: nil)
    }
}

