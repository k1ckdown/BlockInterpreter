import Foundation


enum DelimiterType: CaseIterable {
    case begin
    case end
}


struct BlockDelimiter: IBlock {
    let type: DelimiterType
}


