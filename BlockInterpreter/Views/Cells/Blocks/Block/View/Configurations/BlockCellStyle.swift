//
//  BlockCellStyle.swift
//  BlockInterpreter
//

import Foundation

enum BlockCellStyle {
    case work, presentation
    
    var cornerRadius: CGFloat {
        switch self {
        case .work:
            return 8
        case .presentation:
            return 15
        }
    }
    
    var insetLeading: CGFloat {
        switch self {
        case .work:
            return 7
        case .presentation:
            return 0
        }
    }
    
    func multiplierHeight() -> CGFloat {
        switch self {
        case .work:
            return 1
        case .presentation:
            return 0.75
        }
    }
    
    func multiplierWidth(for blockType: BlockType) -> CGFloat {
        guard self == .work else { return 1 }
        
        switch blockType {
        case .output:
            return 0.95
        case .variable:
            return 0.8
        case .condition:
            return 0.9
        case .loop:
            return 1
        }
    }
}
