//
//  ReuseIdentifier.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 31.05.2023.
//

import Foundation

protocol ReuseIdentifier: AnyObject {
    
}

extension ReuseIdentifier {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
