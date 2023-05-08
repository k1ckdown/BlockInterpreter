import Foundation


enum ConditionType {
    case ifBlock
    case elifBlock
    case elseBlock
}


struct Condition {
    let type: ConditionType
    let value: String
}

