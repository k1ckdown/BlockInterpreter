import Foundation


enum ConditionType {
    case ifBlock
    case elifBlock
    case elseBlock
}


struct Condition: IBlock {
    let id: Int
    let type: ConditionType
    let value: String
}

