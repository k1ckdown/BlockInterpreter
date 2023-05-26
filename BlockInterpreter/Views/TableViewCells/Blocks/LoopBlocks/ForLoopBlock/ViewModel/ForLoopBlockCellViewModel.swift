//
//  ForLoopBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class ForLoopBlockCellViewModel: BlockCellViewModel {
    
    var initValue: String?
    var conditionValue: String?
    var stepValue: String?
    
    var title: String {
        loopType.name.uppercased()
    }
    
    var loopValue: String {
        "\(initValue ?? ""); \(conditionValue ?? ""); \(stepValue ?? "")"
    }
    
    private(set) var loopType: LoopType
 
    init(style: BlockCellStyle) {
        loopType = .forLoop
        super.init(type: .loop(.forLoop), style: style)
    }
    
    override func copyToWork() -> ForLoopBlockCellViewModel {
        let copy = ForLoopBlockCellViewModel(style: .work)
        
        copy.initValue = initValue
        copy.conditionValue = conditionValue
        copy.stepValue = stepValue
        
        return copy
    }
}
