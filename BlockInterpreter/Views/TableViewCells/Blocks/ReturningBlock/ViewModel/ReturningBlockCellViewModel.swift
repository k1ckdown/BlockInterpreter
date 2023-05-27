//
//  ReturningBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class ReturningBlockCellViewModel: BlockCellViewModel {
    
    var returnValue: String?
    
    private(set) var title: String
    private(set) var placeholder: String
    
    init(style: BlockCellStyle) {
        title = "RETURN"
        placeholder = "value"
        super.init(type: .returnBlock, style: style)
    }
    
    override func copyToWork() -> ReturningBlockCellViewModel {
        let copy = ReturningBlockCellViewModel(style: .work)
        copy.returnValue = returnValue
        
        return copy
    }
    
}
