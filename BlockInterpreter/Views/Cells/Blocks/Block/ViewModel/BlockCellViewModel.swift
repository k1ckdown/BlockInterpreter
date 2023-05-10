//
//  BlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

class BlockCellViewModel {
    
    private(set) var isSelect: Bool
    private(set) var type: BlockType
    private(set) var style: BlockCellStyle
    
    init(type: BlockType, style: BlockCellStyle) {
        isSelect = false
        self.type = type
        self.style = style
    }
    
    func select() {
        isSelect = true
    }
    
    func deselect() {
        isSelect = false
    }
}
