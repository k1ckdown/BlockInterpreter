//
//  BlocksSection.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 04.05.2023.
//

import Foundation

enum BlocksSection: String, CaseIterable {
    case variables, control, loops, arrays, functions
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var heightForRow: CGFloat {
        return 85
    }
}
