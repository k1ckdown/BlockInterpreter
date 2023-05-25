import Foundation


enum ConditionType: String, CaseIterable {
    case ifBlock, elifBlock, elseBlock
    var name: String {
        switch self {
        case .ifBlock:
            return "if"
        case .elifBlock:
            return "elif"
        case .elseBlock:
            return "else"
        }
    }
}


struct Condition: IBlock {
    let id: Int
    let type: ConditionType
    let value: String
    let isDebug: Bool
}
