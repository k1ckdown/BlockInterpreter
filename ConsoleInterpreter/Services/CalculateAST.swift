import Foundation
 

class CalculateAST {
    private(set) var text: String
    private(set) var position: Int
    private(set) var currentToken: Token?
 
    init(_ text: String) {
        self.text = text
        position = 0
    }
 
    func setText(text: String) {
        self.text = text
    }
 
    func setPosition(position: Int) {
        self.position = position
    }
 
    func setCurrentToken(currentToken: Token?) {
        self.currentToken = currentToken
    }
 
    func compute() -> Int {
        currentToken = getNextToken()
        var result = term()
 
        while let token = currentToken, token.type == .plus || token.type == .minus {
            if token.type == .plus {
                moveToken(.plus)
                result += term()
            } else if token.type == .minus {
                moveToken(.minus)
                result -= term()
            }
        }
        return result
    }
 
    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
 
    private func isSpace(_ char: Character) -> Bool {
        return char == " "
    }
 
    private func getNextToken() -> Token? {
        guard position < text.count else {
            return Token(.eof, nil)
        }
 
        let currentChar = text[text.index(text.startIndex, offsetBy: position)]
 
        if isSpace(currentChar) {
            position += 1
            return getNextToken()
        }
 
        if isNumber(currentChar) {
            var integerString = String(currentChar)
            position += 1
 
            while position < text.count {
                let nextChar =
                text[text.index(text.startIndex, offsetBy: position)]
                if isNumber(nextChar) {
                    integerString += String(nextChar)
                    position += 1
                } else {
                    break
                }
            }
 
            return Token(.integer, integerString)
        }
 
        position += 1
 
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
            default:
                fatalError("Invalid character")
        }
    }
 
    private func moveToken(_ type: TokenType) {
        if let token = currentToken, token.type == type {
            if !(token.type == .leftBrace) {
                currentToken = getNextToken()
            }
        } else {
            fatalError("Invalid syntax")
        }
    }
 
    private func factor() -> Int {
        let token = currentToken!
 
        if token.type == .integer {
            moveToken(.integer)
            guard let value = token.value, let intValue = Int(value)
            else {
                fatalError("Error parsing input")
            }
            return intValue
        } else if token.type == .leftBrace {
            moveToken(.leftBrace)
            let result = compute()
            moveToken(.rightBrace)
            return result
        }
        return 0
    }
 
    private func term() -> Int {
        var result = factor()
 
        while let token = currentToken, token.type == .modulo || token.type == .multiply
                || token.type == .divide {
            if token.type == .modulo {
                moveToken(.modulo)
                result %= factor()
            }
            else if token.type == .multiply {
                moveToken(.multiply)
                result *= factor()
            } else if token.type == .divide {
                moveToken(.divide)
                result /= factor()
            }
        }
        return result
    }
}
