import Foundation


enum FlowType: CaseIterable {
    case begin, end
}


struct Flow: IBlock {
    let type: FlowType
}


