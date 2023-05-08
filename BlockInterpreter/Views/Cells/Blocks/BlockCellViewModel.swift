//
//  BlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

class BlockCellViewModel {
    
    private(set) var isSelect: Bool
    
    init() {
        isSelect = false
    }
    
    func select() {
        isSelect = true
    }
    
    func deselect() {
        isSelect = false
    }
}
