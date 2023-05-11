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


enum TypeVariable {
    case int
    case double
    case String
    case bool
    case another
}


class Token {
    private var type: TokenType
    private var value: String?
 
    init(_ type: TokenType, _ value: String?) {
        self.type = type
        self.value = value
    }
 
    func getType() -> TokenType {
        return self.type
    }
 
    func setType(type: TokenType) {
        self.type = type
    }
 
    func setValue(value: String?) {
        self.value = value
    }
 
    func getValue() -> String? {
        return value
    }
}


class Variable {
    private let id: Int
    private let type: TypeVariable
    private let name: String
    private var value: String
 
    init(id: Int, type: TypeVariable, value: String, name: String) {
        self.id = id
        self.type = type
        self.value = value
        self.name = name
    }
 
    func getId() -> Int {
        return self.id
    }

    func getType() -> TypeVariable {
        return self.type
    }

    func getName() -> String {
        return self.name
    }

     func getValue() -> String {
        return self.value
    }

    func setValue(value: String) {
        self.value = value
    }
 

}


class AssignmentVariable {
    private var variableIntMap: [String: String] = [:]
    private var calculate: Calculate
 
    init(_ variableInt: [String: String]) {
        self.calculate = Calculate("")
        self.variableIntMap.merge(variableInt){(_, new) in new}
    }
 
    public func setMapOfVariableInt(_ mapOfVariableInt: [String: String]) {
        self.variableIntMap.merge(mapOfVariableInt){(_, new) in new}
    }
 
    public func assign(variable: Variable) -> (String, String) {
        if variable.getType() == TypeVariable.int{
            return assignInt(variable)
        }

        return (variable.getName(), variable.getValue())
        
    }

    private func assignInt(_ variable: Variable) -> (String, String) {
        variable.setValue(value: String(Calculate(normalize(variable.getValue())).compute()))
        return (variable.getName(), variable.getValue())
    }
 
    private func normalize(_ name: String) -> String {
        var result = "" 
        let components = name.split(whereSeparator: { $0 == " " })

        for component in components {
            if let intValue = Int(component) {
                result += "\(intValue)"
            } else if let value = self.variableIntMap[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
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
 
    public func compute() -> Int {
        self.currentToken = self.getNextToken()
        var result = self.term()
 
        while let token = self.currentToken, token.getType() == .plus || token.getType() == .minus {
            if token.getType() == .plus {
                self.moveToken(.plus)
                result += self.term()
            } else if token.getType() == .minus {
                self.moveToken(.minus)
                result -= self.term()
            }
        }
        return result
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

    private func term() -> Int {
        var result = self.factor()
 
        while let token = self.currentToken, token.getType() == .modulo || token.getType() == .multiply || token.getType() == .divide {
            let tokenType = token.getType()
            if  tokenType == .modulo {
                self.moveToken(.modulo)
                result %= self.factor()
            }
            else if tokenType == .multiply {
                self.moveToken(.multiply)
                result *= self.factor()
            } 
            else if tokenType == .divide {
                self.moveToken(.divide)
                result /= self.factor()
            }
        }
        return result
    }

    private func factor() -> Int {
        let token = self.currentToken!
 
        if token.getType() == .integer {
            self.moveToken(.integer)
            guard let value = token.getValue(), let intValue =
                    Int(value) else { fatalError("Error parsing input")
            }
            return intValue
        } else if token.getType() == .leftBrace {
            self.moveToken(.leftBrace)
            let result = compute()
            self.moveToken(.rightBrace)
            return result
        }
        return 0
    }
 
    private func moveToken(_ type: TokenType) {
        if let token = self.currentToken, token.getType() == type, !(token.getType() == .leftBrace) {
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


var variableIntMap: [String: String] = [:]
 
 
var variableForInt = Variable(
    id: 1,
    type: TypeVariable.int,
    value: "12 + 15",
    name: "a"
    )
    
var assignVariableInt = AssignmentVariable(variableIntMap)
var mapElement = assignVariableInt.assign(
    variable: variableForInt
    )
variableIntMap[mapElement.0] = mapElement.1
print(variableIntMap)
 
 
variableForInt = Variable(
    id: 2,
    type: TypeVariable.int,
    value: "a / 3 + 7",
    name: "b"
    )
assignVariableInt = AssignmentVariable(variableIntMap)
mapElement = assignVariableInt.assign(
    variable: variableForInt
    )
variableIntMap[mapElement.0] = mapElement.1
print(variableIntMap)

