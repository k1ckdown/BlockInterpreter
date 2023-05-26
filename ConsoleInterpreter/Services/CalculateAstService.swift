import Foundation
 

class Calculate { 
    private var text: String
    private var position: Int
    private var currentToken: Token?
    private var nodeId: Int = 0
    private var consoleOutput: ConsoleOutput
 
 
    init(_ text: String, _ nodeId: Int) {
        self.text = text
        self.position = 0
        self.nodeId = nodeId
        self.consoleOutput =  ConsoleOutput(errorOutputValue: "", errorIdArray: [])
    }
 
    public func getText() -> String {
        return text
    }
 
    public func setText(text: String) {
        self.text = text
        self.position = 0
    }
 
 
    public func compare() throws -> Double {
        currentToken = try getNextToken() 
 
        var result = try term()
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
            return Double(result)
        }
        while let token = currentToken, possibleTokens.contains(token.getType()) {
 
            if token.getType() == .plus {
                try  moveToken(.plus)
                result += try term()
            } else if token.getType() == .minus {
                try  moveToken(.minus)
                result -= try term()
            } else if possibleTokens.contains(token.getType()){
                try  moveToken(token.getType())
                let factorValue =  try factor()
 
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
                    throw ErrorType.invalidTokenTypeError
                }
            }
        }
        return Double(result)
    }
 
 
 
    private func term() throws -> Double {
        var result = try factor()
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
                try moveToken(.modulo)
                result = Double(Int(result) % Int(try factor()))
            case .multiply:
                try moveToken(.multiply)
                result *= try factor()
 
            case .divide:
                try moveToken(.divide)
                result /= try factor()
 
            default:
                throw ErrorType.invalidTokenTypeError
            }
        }
        return result
    }
 
 
    private func factor()throws -> Double {
        guard let token = currentToken else{
            throw ErrorType.invalidTokenTypeError
        }
 
        switch token.getType() {
        case .integer:
            try moveToken(.integer)
            guard let 
                value = token.getValue(), 
                let intValue = Int(value),
                intValue <= Int.max 
            else { throw ErrorType.integerOwerflowError}
            return Double(intValue)
        case .double:
            try moveToken(.double)
            guard let value = token.getValue(), let doubleValue =
                Double(value) else {
                fatalError("Error parsing input")
            }
            return Double(doubleValue)
        case .minus:
            try moveToken(.minus)
            return try factor() * -1
        case .leftBrace:
            try moveToken(.leftBrace)
            let result = try compare()
            try moveToken(.rightBrace)
            return Double(result)
        case .eof:
            return 0
        default:
            print(token.getType(), text)
            throw ErrorType.invalidTokenTypeError
        }
    }
 
    public func compareString() throws -> String{
        currentToken = try getNextToken() 
        var result = ""
        result += try termString()
 
        let possibleTokens: [TokenType] = [
            .leftQuote,
            .rightQuote,
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
            if token.getType() == .leftQuote {
                try moveToken(.leftQuote)
                result += try termString()
            } else if token.getType() == .rightQuote {
                try moveToken(.rightQuote)
                result += try termString()
            } else if token.getType() == .plus {
                try moveToken(.plus)
                result += try termString()
            } else if possibleTokens.contains(token.getType()){
                try moveToken(token.getType())
                let factorValue = try factorString()
 
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
                    throw ErrorType.invalidTokenTypeError
                }
            }
        }
        return result
    }
 
    private func termString() throws -> String {
        var result = try factorString()
        if currentToken == nil {
            return result
        }
        if currentToken?.getType() == .rightQuote {
            try moveToken(.rightQuote)
        }
        while let token = currentToken, token.getType() == .multiply {
            switch token.getType() {
            case .multiply:
                try moveToken(.multiply)
                let factorValue = try factorString()
                guard let firstChar = factorValue.first else{
                    throw ErrorType.invalidSyntaxError
                }
                if !isNumber(firstChar){
                    throw ErrorType.invalidSyntaxError
                }
                let oldResult = result
                if let factorValue = Int(String(firstChar)){
                    result = ""
                    for _ in 0..<factorValue{
                        result += oldResult
                    }
                } else {
                    throw ErrorType.invalidSyntaxError
                }
 
            default:
                throw ErrorType.invalidTokenTypeError
            }
        }
        return result
    }
 
    private func factorString() throws -> String {
        guard let token = currentToken else{
            throw ErrorType.nilTokenError
        }
 
        switch token.getType() {
        case .integer:
            try moveToken(.integer)
            return token.getValue() ?? ""
        case .string:
            try moveToken(.string)
            return token.getValue() ?? ""
        case .double:
            try moveToken(.double)
            return token.getValue() ?? ""
        case .leftBrace:
            try moveToken(.leftBrace)
            let result = try compareString()
            try moveToken(.rightBrace)
            return result
        case .eof:
            try moveToken(.eof)
            return token.getValue() ?? ""
        default:
            print(token.getType())
            print(text)
            throw ErrorType.invalidSyntaxError
        } 
    }
 
 
    private func getNextToken()throws -> Token? { 
        guard position < text.count else {
            return Token(.eof, nil)
        }
 
        let currentChar = text[text.index(text.startIndex, offsetBy: position)]
 
        if isSpace(currentChar) {
            var nextChar = text[text.index(text.startIndex, offsetBy: position)]
            while isSpace(nextChar) {
                position += 1
                nextChar = text[text.index(text.startIndex, offsetBy: position)]
            }
            return try getNextToken()
        } else if isNumber(currentChar) {
            var integerString = String(currentChar), isDouble = false
            position += 1
 
            while position < text.count {
                let nextChar = text[text.index(text.startIndex, offsetBy: position)]
                if isNumber(nextChar) {
                    integerString += String(nextChar)
                    position += 1
                } else if (nextChar == ".") {
                    integerString += String(nextChar)
                    position += 1
                    isDouble = true
                } else {
                    break
                }
            }
 
            if isDouble {
                return Token(.double, integerString)
            } else {
                return Token(.integer, integerString)
            }
 
        } else if currentChar == "“"{
            var string = ""
            position += 1
            while position < text.count {
                let nextChar = text[text.index(text.startIndex, offsetBy: position)]
                if nextChar != "”" {
                    string += String(nextChar)
                    position += 1
                } else {
                    break
                }
            }
            return Token(.string, string)
        } else if currentChar == "." {
            position += 1
            //           return Token(.double, ".")
        }
 
        position += 1
        do {
            return try getToken(currentChar)
        } catch let errorType as ErrorType {
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput
        }
 
    }
 
    private func getToken(_ currentChar: Character)throws -> Token{ // функция для получения токена в виде TokenType и его символа (только арифметические операции)
        switch currentChar {
        case "“":
            return Token(.leftQuote, "“")
        case "”":
            return Token(.rightQuote, "”")
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
        case ".":
            return Token(.double, ".")
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
                    throw ErrorType.invalidSyntaxError
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
                        throw ErrorType.invalidSyntaxError
                    }
 
                case "|":
                    if self.position < self.text.count && self.text[self.text.index(self.text.startIndex, offsetBy: self.position)] == "|" {
                        self.position += 1
                        return Token(.logicalOr, "||")
                    } else {
                        throw ErrorType.invalidSyntaxError
                    }
                default:
                    throw ErrorType.invalidSyntaxError
                }
            }
        default:
            print(currentChar) 
            throw ErrorType.invalidSyntaxError
        }
    }
    private func moveToken(_ type: TokenType) throws {
        if let token = currentToken, token.getType() == type{
            if !(token.getType() == .leftBrace) {
                currentToken = try getNextToken()
            }
        } else {
            throw ErrorType.invalidSyntaxError
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
