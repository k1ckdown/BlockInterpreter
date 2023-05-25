import Foundation

enum FlowType: CaseIterable {
    case begin
    case end
    case continueCondition
    case breakCondition
}

struct Flow: IBlock {
    let type: FlowType
}


