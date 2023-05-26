//
//  FlowBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class FlowBlockCellViewModel: BlockCellViewModel {
    
    var title: String {
        flowBlockStyle.title
    }
    
    private(set) var flowType: FlowType
    private(set) var flowBlockStyle: FlowBlockStyle
    
    init(flowType: FlowType, style: BlockCellStyle) {
        self.flowType = flowType
        
        switch flowType {
        case .begin:
            flowBlockStyle = .begin
        case .end:
            flowBlockStyle = .end
        case .continueCondition:
            flowBlockStyle = .continueСondition
        case .breakCondition:
            flowBlockStyle = .breakCondition
        }
        
        super.init(type: .flow, style: style)
    }
    
    override func copyToWork() -> FlowBlockCellViewModel {
        return FlowBlockCellViewModel(flowType: flowType, style: .work)
    }
    
}
