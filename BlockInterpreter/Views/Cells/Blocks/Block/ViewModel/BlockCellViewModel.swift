//
//  BlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

class BlockCellViewModel {
    
    var isWiggleMode: Bool
    private(set) var isSelect: Bool
    private(set) var type: BlockType
    private(set) var style: BlockCellStyle
    
    init(type: BlockType, style: BlockCellStyle) {
        isSelect = false
        isWiggleMode = false
        self.type = type
        self.style = style
    }
    
    func select() {
        isSelect = true
    }
    
    func deselect() {
        isSelect = false
    }
    
    func updateStyle(style: BlockCellStyle) {
        self.style = style
    }
    
    func copyToWork() -> BlockCellViewModel {
        return BlockCellViewModel(type: type, style: .work)
    }
    
}
