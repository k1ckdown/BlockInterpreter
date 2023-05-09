import Foundation


enum LoopType {
    case forLoop
    case whileLoop
}


struct Loop {
    let type: LoopType
    let value: String
}
