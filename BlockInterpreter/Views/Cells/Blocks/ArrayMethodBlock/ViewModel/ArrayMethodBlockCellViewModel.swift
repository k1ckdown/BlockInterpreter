//
//  ArrayMethodBlockCellViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 25.05.2023.
//

import Foundation

final class ArrayMethodBlockCellViewModel: BlockCellViewModel {
    
    var arrayName: String?
    var value: String?
    
    var title: String {
        ".\(methodType.rawValue)"
    }
    
    private(set) var methodType: ArrayMethodType
    
    init(methodType: ArrayMethodType, style: BlockCellStyle) {
        self.methodType = methodType
        super.init(type: .arrayMethod, style: style)
    }
    
    override func copyToWork() -> BlockCellViewModel {
        let copy = ArrayMethodBlockCellViewModel(methodType: methodType, style: .work)
        
        copy.arrayName = arrayName
        copy.value = value
        
        return copy
    }
}
