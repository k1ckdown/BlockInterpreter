import Foundation
 
enum TokenType {
    case integer
    case string
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
    case logicalAnd
    case logicalOr
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
        position = 0
    }
 
    public func getText() -> String {
        return self.text
    }
 
    public func setText(text: String) {
        self.text = text
        self.position = 0
    }

    public func compare() -> Int {
        self.currentToken = self.getNextToken() 
        var result = self.term()
        let possibleTokens: [TokenType] = [
            TokenType.plus,
            TokenType.minus,
            TokenType.equal,
            TokenType.less, 
            TokenType.greater,
            TokenType.notEqual,
            TokenType.lessEqual,
            TokenType.greaterEqual,
            TokenType.logicalAnd,
            TokenType.logicalOr
        ]
        if self.currentToken == nil {
            return result
        }
        while let token = self.currentToken, possibleTokens.contains(token.type) {
            
            if token.type == .plus {
                moveToken(.plus)
                result += term()
            } else if token.type == .minus {
                moveToken(.minus)
                result -= term()
            } else if possibleTokens.contains(token.type){
                self.moveToken(token.type)
                let factorValue = self.factor()

                switch token.type {
                case .equal:
                    result = result == factorValue ? 1 : 0
                case .notEqual:
                    result = result != factorValue ? 1 : 0
                case .greater:
                    result = result > factorValue ? 1 : 0
                case .less:
                    result = result < factorValue ? 1 : 0
                case .greaterEqual:
                    result = result >= factorValue ? 1 : 0
                case .lessEqual:
                    result = result <= factorValue ? 1 : 0
                case .logicalAnd:
                    result = result != 0  && factorValue != 0  ? 1 : 0
                case .logicalOr:
                    result = result != 0 || factorValue != 0  ? 1 : 0
                default:
                    fatalError("Invalid token type")
                }
            }
        }
        return result
    }



    private func term() -> Int {
        var result = self.factor()
        let possibleTokens: [TokenType] = [
            TokenType.modulo,
            TokenType.multiply,
            TokenType.divide,
        ]
        if self.currentToken == nil {
            return result
        }
        while let token = self.currentToken, possibleTokens.contains(token.type){
            switch token.type {
            case .modulo:
                self.moveToken(.modulo)
                result %= self.factor()
            case .multiply:
                self.moveToken(.multiply)
                result *= self.factor()

            case .divide:
                self.moveToken(.divide)
                result /= self.factor()
            
            default:
                fatalError("Invalid token type")
            }
        }
        return result
    }

    private func factor() -> Int {
        let token = self.currentToken!

        switch token.type {
            case .integer:
                self.moveToken(.integer)
                guard let value = token.value, let intValue =
                        Int(value) else { fatalError("Error parsing input")
                }
                return intValue
            case .leftBrace:
                self.moveToken(.leftBrace)
                let result = self.compare()
                self.moveToken(.rightBrace)
                return result
            case .eof:
                return 0
            default:
                print(token.type)
                fatalError("Invalid syntax")
        }

    }
 

    private func getNextToken() -> Token? {
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
        return getToken(currentChar)
        
    }

    private func getToken(_ currentChar: Character) -> Token{
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
            case "=", "<", ">", "!", "&", "|":
                if self.position < self.text.count && self.text[self.text.index(self.text.startIndex, offsetBy: self.position)] == "=" {
                    self.position += 1
                    switch currentChar {
                        case "=":
                            return Token(.equal, "==")
                        case "!":
                            return Token(.notEqual, "!=")
                        case "<":
                            return Token(.lessEqual, "<=")
                        case ">":
                            return Token(.greaterEqual, ">=")
                        default:
                            fatalError("Invalid character")
                    }
                } else {
                    switch currentChar {
                        case "=":
                            return Token(.equal, "=")
                        case "<":
                            return Token(.less, "<")
                        case ">":
                            return Token(.greater, ">")
                        case "&":
                            if self.position < self.text.count && self.text[self.text.index(self.text.startIndex, offsetBy: self.position)] == "&" {
                                self.position += 1
                                return Token(.logicalAnd, "&&")
                            } else {
                                fatalError("Invalid character")
                            }
                            
                        case "|":
                            if self.position < self.text.count && self.text[self.text.index(self.text.startIndex, offsetBy: self.position)] == "|" {
                                self.position += 1
                                return Token(.logicalOr, "||")
                            } else {
                                fatalError("Invalid character")
                            }
                        default:
                            fatalError("Invalid character")
                    }
                }
            default:
                fatalError("Invalid character")
        }
    }
    private func moveToken(_ type: TokenType) {
        if let token = currentToken, token.type == type{
            if !(token.type == .leftBrace) {
                currentToken = getNextToken()
            }
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


let calculator = Calculate("")
print(1, calculator.compare()) // Output: 0


calculator.setText(text: "8 == 8")
print(2, calculator.compare()) // Output: 1

calculator.setText(text: "8 == 9")
print(3, calculator.compare()) // Output: 0

calculator.setText(text: "8 != 8")
print(4, calculator.compare()) // Output: 0

calculator.setText(text: "8 != 9")
print(5, calculator.compare()) // Output: 1

calculator.setText(text: "8 > 8")
print(6, calculator.compare()) // Output: 0

calculator.setText(text: "8 > 7")
print(7, calculator.compare()) // Output: 1

calculator.setText(text: "8 < 8")
print(8, calculator.compare()) // Output: 0

calculator.setText(text: "8 <= 9")
print(9, calculator.compare()) // Output: 1

calculator.setText(text: "8 >= 8")
print(10, calculator.compare()) // Output: 1

calculator.setText(text: "8 >= 9")
print(11, calculator.compare()) // Output: 0

calculator.setText(text: "8 && 9")
print(12, calculator.compare()) // Output: 1

calculator.setText(text: "8 || 9")
print(13, calculator.compare()) // Output: 1

calculator.setText(text: "8 && 0")
print(14, calculator.compare()) // Output: 0

calculator.setText(text: "8 + 17")
print(calculator.compare()) // Output: 25

calculator.setText(text: "8 + 17 * 2")
print(calculator.compare()) // Output: 42


calculator.setText(text: "8 + 17 * 2 - 4")
print(calculator.compare()) // Output: 38

calculator.setText(text: "( 8 + 17 * 2 - 4 / 2 ) % 3")
print(calculator.compare()) // Output: 2

calculator.setText(text: "( 8 + 17 * 2 - 4 ) / 2 % 3")
print(calculator.compare()) // Output: 1



// ---- correct output ----
// 1 0
// 2 1
// 3 0
// 4 0
// 5 1
// 6 0
// 7 1
// 8 0
// 9 1
// 10 1
// 11 0
// 12 1
// 13 1
// 14 0
// 25
// 42
// 38
// 2
// 2
