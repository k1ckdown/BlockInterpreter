//
//  BlocksSection.swift
//  BlockInterpreter
//

import Foundation

enum BlocksSection: String, CaseIterable {
    case variables, conditions, loops, arrays, functions
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var heightForRow: CGFloat {
        return 90
    }
}
