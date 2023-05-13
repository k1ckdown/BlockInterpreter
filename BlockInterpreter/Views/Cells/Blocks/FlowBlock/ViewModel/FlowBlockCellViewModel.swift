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
        flowBlockStyle = flowType == .begin ? .begin : .end
        super.init(type: .flow, style: style)
    }
    
    override func copyToWork() -> FlowBlockCellViewModel {
        return FlowBlockCellViewModel(flowType: flowType, style: .work)
    }
    
}
