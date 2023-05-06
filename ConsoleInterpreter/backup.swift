import Foundation


//* -----------------ENITITY ---------------------

//!----------------------
//!  Token.swift



class Token {
    private var type: TokenType
    private var value: String?
 
    init(_ type: TokenType, _ value: String?) {
        self.type = type
        self.value = value
    }
 
    public func getType() -> TokenType {
        return self.type
    }
 
    public func setType(type: TokenType) {
        self.type = type
    }
 
    public func setValue(value: String?) {
        self.value = value
    }
 
    public func getValue() -> String? {
        return value
    }
}


//!----------------------
//!  Variable.swift

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
 
    public func getId() -> Int {
        return self.id
    }
 
    public func getName() -> String {
        return self.name
    }
 
    public func getType() -> TypeVariable {
        return self.type
    }
 
    public func setValue(value: String) {
        self.value = value
    }
 
    public func getValue() -> String {
        return self.value
    }
}



//* -----------------ENUMS ---------------------

//!----------------------
//!  TokenType.swift

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


//!----------------------
//!  TypeVariable.swift


enum TypeVariable {
    case int
    case double
    case String
    case bool
    case another
}


//* ----------------- SERVICE ---------------------

//!----------------------
//!  AssignVariableInt.swift



 
class AssignmentVariableInt {
    private var mapOfVariablesInt: [String: String] = [:]
    private var calculate: Calculate
 
    init(_ variableInt: [String: String]) {
        self.calculate = Calculate("")
        self.mapOfVariablesInt.merge(variableInt){(_, new) in new}
    }
 
    public func setmapOfVariableInt(_ mapOfVariableInt: [String: String]) {
        self.mapOfVariablesInt.merge(mapOfVariableInt){(_, new) in new}
    }
 
    public func assignInt(variable: Variable) -> (String, String) {
        variable.setValue(value: String(Calculate(normalize(variable.getValue())).compute()))
        return (variable.getName(), variable.getValue())
    }
 
    private func normalize(_ name: String) -> String {
        var result = ""
        let components = name.split(whereSeparator: { $0 == " " })
        for component in components {
            if let intValue = Int(component) {
                result += "\(intValue)"
            } else if let value = self.mapOfVariablesInt[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }
}









//!----------------------
//!  Calculate.swift

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
 
    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
 
    private func isSpace(_ char: Character) -> Bool {
        return char == " "
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
 
    private func moveToken(_ type: TokenType) {
        if let token = self.currentToken, token.getType() == type {
            if !(token.getType() == .leftBrace) {
                self.currentToken = getNextToken()
            }
        } else {
            fatalError("Invalid syntax")
        }
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
 
    private func term() -> Int {
        var result = self.factor()
 
        while let token = self.currentToken, token.getType() == .modulo || token.getType() == .multiply || token.getType() == .divide {
            if token.getType() == .modulo {
                self.moveToken(.modulo)
                result %= self.factor()
            }
            else if token.getType() == .multiply {
                self.moveToken(.multiply)
                result *= self.factor()
            } else if token.getType() == .divide {
                self.moveToken(.divide)
                result /= self.factor()
            }
        }
        return result
    }
}






//* --------------------------------------------
//* ----------------- MAIN ---------------------
//* --------------------------------------------

var mapOfVariablesInt: [String: String] = [:]
 
 
var variableForInt = Variable(id: 1, type: TypeVariable.int,
                              value: "12 + 15", name: "a")
var assignVariableInt = AssignmentVariableInt(mapOfVariablesInt)
var nameAndValueOfVariable = assignVariableInt.assignInt(variable: variableForInt)
mapOfVariablesInt[nameAndValueOfVariable.0] = nameAndValueOfVariable.1
print(mapOfVariablesInt)
 
 
variableForInt = Variable(id: 2, type: TypeVariable.int,
                          value: "a / 3", name: "b")
assignVariableInt = AssignmentVariableInt(mapOfVariablesInt)
nameAndValueOfVariable = assignVariableInt.assignInt(variable: variableForInt)
mapOfVariablesInt[nameAndValueOfVariable.0] = nameAndValueOfVariable.1
print(mapOfVariablesInt)

 