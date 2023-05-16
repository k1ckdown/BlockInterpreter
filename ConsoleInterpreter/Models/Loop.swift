import Foundation


enum LoopType {
    case forLoop, whileLoop
    
    var name: String {
        switch self {
        case .forLoop:
            return "for"
        case .whileLoop:
            return "while"
        }
    }
}


struct Loop: IBlock {
    let id: Int
    let type: LoopType
    let value: String
}
