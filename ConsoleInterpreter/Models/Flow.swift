import Foundation


enum FlowType {
    case begin
    case end
}


struct Flow: IBlock {
    let type: FlowType
}


