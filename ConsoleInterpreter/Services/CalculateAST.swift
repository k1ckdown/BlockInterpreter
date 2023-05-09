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
    case equal
    case notEqual
    case greater
    case less
    case greaterEqual
    case lessEqual 
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


class Calculate {
    private var text: String
    private var position: Int
    private var currentToken: Token?
 
    init(_ text: String) {
        self.text = text
        self.position = 0
        self.currentToken = nil
    }
 
    public func getText() -> String {
        return self.text
    }
 
    public func setText(text: String) {
        self.text = text
    }
    // public func compare() -> Bool{

    // }
    public func compute() -> Int {
        self.currentToken = self.getNextToken() 
        var result = self.term()
 
        while let token = self.currentToken, [TokenType.minus, TokenType.plus].contains(token.type) {
            if token.type == .plus {
                self.moveToken(.plus)
                result += self.term()
            } else if token.type == .minus {
                self.moveToken(.minus)
                result -= self.term()
            }
        }
        return result
    }


    private func getNextToken() -> Token? { // возвращает следующую подстроку, которая не является пробелом
        guard self.position < self.text.count else {
            return Token(.eof, nil)
        }
 
        let currentChar = self.text[self.text.index(self.text.startIndex, offsetBy: self.position)]
 
        if self.isSpace(currentChar) {
            self.position += 1
            return self.getNextToken()
        }
 
        if self.isNumber(currentChar) {
            var integerString = String(currentChar)
            self.position += 1
 
            while self.position < self.text.count {
                let nextChar =
                self.text[self.text.index(self.text.startIndex, offsetBy: self.position)]
                if self.isNumber(nextChar) {
                    integerString += String(nextChar)
                    self.position += 1
                } else {
                    break
                }
            }

            return Token(.integer, integerString)
        }

        self.position += 1
 
        switch currentChar {
            case "+":
                return Token(.plus, "+")            
            case "-":
                return Token(.minus, "-")
            case "*":
                return Token(.multiply, "*")
            case "/":
                return Token(.divide, "/")
            case "%":
                return Token(.modulo, "%")
            case "(":
                return Token(.leftBrace, "(")
            case ")":
                return Token(.rightBrace, ")")
            case "<":
                if self.position < self.text.count && self.text[self.text.index(self.text.startIndex, offsetBy: self.position)] == "=" {
                    self.position += 1
                    return Token(.lessEqual, "<=")
                } else {
                    return Token(.less, "<")
                }
            case ">":
                if self.position < self.text.count && self.text[self.text.index(self.text.startIndex, offsetBy: self.position)] == "=" {
                    self.position += 1
                    return Token(.greaterEqual, ">=")
                } else {
                    return Token(.greater, ">")
                }
            default:
                fatalError("Invalid character")
        }
    }

    private func term() -> Int {
        var result = self.factor()
        let possibleTokens = [
            TokenType.modulo,
            TokenType.multiply,
            TokenType.divide,
            TokenType.equal,
            TokenType.less, 
            TokenType.greater,
            TokenType.notEqual,
            TokenType.lessEqual,
            TokenType.greaterEqual
            ]
        
        while let token = self.currentToken, token.type == .modulo || token.type == .multiply || token.type == .divide {
            if  token.type == .modulo {
                self.moveToken(.modulo)
                result %= self.factor()
            }
            else if token.type == .multiply {
                self.moveToken(.multiply)
                result *= self.factor()
            } 
            else if token.type == .divide {
                self.moveToken(.divide)
                result /= self.factor()
            }
        }
        return result
    }

    private func factor() -> Int {
        let token = self.currentToken!
 
        if token.type == .integer {
            self.moveToken(.integer)
            guard let value = token.value, let intValue =
                    Int(value) else { fatalError("Error parsing input")
            }
            return intValue
        } else if token.type == .leftBrace {
            self.moveToken(.leftBrace)
            let result = compute()
            self.moveToken(.rightBrace)
            return result
        }
        return 0
    }
 
    private func moveToken(_ type: TokenType) {
        if let token = self.currentToken, token.type == type, !(token.type == .leftBrace) {
            self.currentToken = getNextToken()
        } else {
            fatalError("Invalid syntax")
        }
    }

    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }

    private func isSpace(_ char: Character) -> Bool {
        return char == " "
    }
}
