//
//  FlowBlockStyle.swift
//  BlockInterpreter
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
