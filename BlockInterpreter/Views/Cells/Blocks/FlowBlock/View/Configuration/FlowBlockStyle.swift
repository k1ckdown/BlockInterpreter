//
//  FlowBlockStyle.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 13.05.2023.
//

import UIKit

enum FlowBlockStyle: String {
    case begin, end
    
    var title: String {
        self.rawValue.uppercased()
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .begin:
            return .beginBlock
        case .end:
            return .endBlock
        }
    }
}
