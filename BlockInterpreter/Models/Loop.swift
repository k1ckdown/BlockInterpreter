import Foundation


enum LoopType {
    case forLoop
    case whileLoop
}


struct Loop: IBlock {
    let id: Int
    let type: LoopType
    let value: String
}
