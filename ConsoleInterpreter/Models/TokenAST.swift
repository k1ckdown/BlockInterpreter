import Foundation
 

enum TokenType {
    case integer
    case plus
    case minus
    case multiply
    case divide
    case eof
    case leftBrace
    case rightBrace
    case modulo
}


class Token {
    private(set) var type: TokenType
    private(set) var value: String?
 
    init(_ type: TokenType, _ value: String?) {
        self.type = type
        self.value = value
    }
 
    func setType(type: TokenType) {
        self.type = type
    }
 
    func setValue(value: String?) {
        self.value = value
    }
}
