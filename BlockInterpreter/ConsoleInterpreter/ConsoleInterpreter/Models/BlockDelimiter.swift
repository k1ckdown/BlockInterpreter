import Foundation


enum DelimiterType {
    case begin
    case end
}


struct BlockDelimiter: IBlock {
    let type: DelimiterType
}
