//
//  LabelTFBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

class LabelTFBlockCellViewModel: BlockCellViewModel {
    
    var text: String?
    
    private(set) var title: String
    private(set) var placeholder: String
    
    init(title: String, placeholder: String, type: BlockType, style: BlockCellStyle) {
        self.title = title.uppercased()
        self.placeholder = placeholder
        super.init(type: type, style: style)
    }
    
}
