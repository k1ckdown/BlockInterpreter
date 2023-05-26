import Foundation


enum FlowType {
    case begin
    case end
    case continueFlow
    case breakFlow
}


struct Flow: IBlock {
    let id: Int
    let type: FlowType
    let isDebug: Bool
}