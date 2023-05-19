import Foundation
 

class Calculate { 
    private var text: String
    private var position: Int
    private var currentToken: Token?
    
    init(_ text: String) {
        self.text = text
        self.position = 0
    }
 
    public func getText() -> String {
        return text
    }
 
    public func setText(text: String) {
        self.text = text
        self.position = 0
    }

    
    public func compare() -> Int {
        currentToken = getNextToken() 
        
        var result = term()
        let possibleTokens: [TokenType] = [
            .plus,
            .minus,
            .equal,
            .less,  
            .greater,
            .notEqual,
            .lessEqual,
            .greaterEqual,
            .logicalAnd,
            .logicalOr
        ]
        if currentToken == nil {
            return result
        }
        while let token = currentToken, possibleTokens.contains(token.getType()) {
            
            if token.getType() == .plus {
                moveToken(.plus)
                result += term()
            } else if token.getType() == .minus {
                moveToken(.minus)
                result -= term()
            } else if possibleTokens.contains(token.getType()){
                moveToken(token.getType())
                let factorValue = factor()

                switch token.getType() {
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
        var result = factor()
        let possibleTokens: [TokenType] = [
            TokenType.modulo,
            TokenType.multiply,
            TokenType.divide,
        ]
        if currentToken == nil {
            return result
        }
        while let token = currentToken, possibleTokens.contains(token.getType()) {
            switch token.getType() {
            case .modulo:
                moveToken(.modulo)
                result %= factor()
            case .multiply:
                moveToken(.multiply)
                result *= factor()

            case .divide:
                moveToken(.divide)
                result /= factor()
            
            default:
                fatalError("Invalid token type")
            }
        }
        return result
    }


    private func factor() -> Int {
        let token = currentToken!

        switch token.getType() {
            case .integer:
                moveToken(.integer)
                guard let value = token.getValue(), let intValue =
                        Int(value) else { fatalError("Error parsing input")
                }
                return intValue
            case .minus:
                moveToken(.minus)
                return -factor()
            case .leftBrace:
                moveToken(.leftBrace)
                let result = compare()
                moveToken(.rightBrace)
                return result

            case .eof:
                return 0
            default:
                print(token.getType())
                fatalError("Invalid syntax")
        }
    }

    public func compareString() -> String{
        currentToken = getNextToken() 
        var result = ""
        result += termString()
        let possibleTokens: [TokenType] = [
            .plus,
            .equal,
            .less,  
            .greater,
            .notEqual,
            .lessEqual,
            .greaterEqual,
            .logicalAnd,
            .logicalOr
        ]
        if currentToken == nil {
            return result
        }
        while let token = currentToken, possibleTokens.contains(token.getType()) {
            
            if token.getType() == .plus {
                moveToken(.plus)
                result += termString()
            } else if possibleTokens.contains(token.getType()){
                moveToken(token.getType())
                let factorValue = factorString()

                switch token.getType() {
                case .equal:
                    result = result == factorValue ? "true" : "false"
                case .notEqual:
                    result = result != factorValue ? "true" : "false"
                case .greater:
                    result = result > factorValue ? "true" : "false"
                case .less:
                    result = result < factorValue ? "true" : "false"
                case .greaterEqual:
                    result = result >= factorValue ? "true" : "false"
                case .lessEqual:
                    result = result <= factorValue ? "true" : "false"
                case .logicalAnd:
                    result = result != ""  && factorValue != ""  ? "true" : "false"
                case .logicalOr:
                    result = result != "" || factorValue != ""  ? "true" : "false"
                default:
                    fatalError("Invalid token type")
                }
            }
        }
        return result
    }

    private func termString() -> String {
        var result = factorString()

        let possibleTokens: [TokenType] = [
            TokenType.multiply,
        ]
        if currentToken == nil {
            return result
        }
        while let token = currentToken, possibleTokens.contains(token.getType()) {
            switch token.getType() {
            case .multiply:
                moveToken(.multiply)
                let factorValue = factorString()
                if !isNumber(factorValue.first!){
                    fatalError("Invalid syntax")
                }
                let oldResult = result
                for _ in 0..<Int(factorValue)! - 1{
                    result += oldResult
                }
            default:
                fatalError("Invalid token type")
            }
        }
        return result
    }

    private func factorString() -> String {
        let token = currentToken!

        switch token.getType() {
        case .integer:
            moveToken(.integer)
            return token.getValue() ?? ""
        case .string:
            moveToken(.string)
            return token.getValue() ?? ""
        case .leftBrace:
            moveToken(.leftBrace)
            let result = compareString()
            moveToken(.rightBrace)
            return result
        default:
            print(token.getType())
            fatalError("Invalid syntax")
        } 
    }
 

    private func getNextToken() -> Token? { 
        guard position < text.count else {
            return Token(.eof, nil)
        }
 
        let currentChar = text[text.index(text.startIndex, offsetBy: position)]
        if isSpace(currentChar) {
            position += 1
            return getNextToken()
        } else if isNumber(currentChar) {
            var integerString = String(currentChar)
            position += 1
 
            while position < text.count {
                let nextChar = text[text.index(text.startIndex, offsetBy: position)]
                if isNumber(nextChar) {
                    integerString += String(nextChar)
                    position += 1
                } else {
                    break
                }
            }

            return Token(.integer, integerString)
        } else if isChar(currentChar) {
            var string = String(currentChar)
            position += 1
            
            while position < text.count {
                let nextChar = text[text.index(text.startIndex, offsetBy: position)]


                if nextChar != "*" && nextChar != "+" { //* добавить операторы сравнения
                    string += String(nextChar)
                    position += 1
                } else {
                    break
                }
            }

            
            return Token(.string, string)

        }


        position += 1
        return getToken(currentChar)
        
    }

    private func getToken(_ currentChar: Character) -> Token{ // функция для получения токена в виде TokenType и его символа (только арифметические операции)
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
                print(currentChar)
                fatalError("Invalid character")
        }
    }
    private func moveToken(_ type: TokenType) {
        if let token = currentToken, token.getType() == type{
            if !(token.getType() == .leftBrace) {
                currentToken = getNextToken()
            }
        } else {
            fatalError("Invalid syntax")
        }
    }

    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }

    private func isChar(_ char: Character) -> Bool {
        return char >= "a" && char <= "z" || char >= "A" && char <= "Z"
    }


    private func isSpace(_ char: Character) -> Bool {
        return char == " "
    }
}
