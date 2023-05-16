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
            return 12
        case .presentation:
            return 18
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
        guard
            self == .work
        else {
            if blockType.isEqualTo(.flow) {
                return 0.6
            } else {
                return 1
            }
        }
        
        switch blockType {
        case .output:
            return 0.95
        case .flow:
            return 0.35
        case .variable:
            return 0.8
        case .condition:
            return 0.9
        case .loop:
            return 0.85
        }
    }
}
