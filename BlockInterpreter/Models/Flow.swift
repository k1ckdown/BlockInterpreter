import Foundation


enum FlowType: CaseIterable {
    case begin
    case end
}


struct Flow: IBlock {
    let type: FlowType
}


