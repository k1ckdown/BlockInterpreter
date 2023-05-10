import Foundation


enum LoopType {
    case forLoop
    case whileLoop
}


struct Loop {
    let id: Int
    let type: LoopType
    let value: String
}
