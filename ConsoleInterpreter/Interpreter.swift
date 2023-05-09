
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
    case greaterThan
    case lessThan
    case greaterEqual
    case lessEqual 
}


enum VariableType {
    case int
    case double
    case String
    case bool
    case another
}


enum AllTypes {
    case assign
    case ifBlock
    case begin
    case end
    case loop
    case function
    case variable
    case arithmetic
    case print
    case root
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
    private let type: VariableType
    private var value: String
 
    init(id: Int, type: VariableType, value: String) {
        self.id = id
        self.type = type
        self.value = value
    }
 
    func getId() -> Int {
        return self.id
    }

    func getType() -> VariableType {
        return self.type
    }

    func getValue() -> String {
        return self.value
    }

    func setValue(_ value: String) {
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
    }

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
        let possibleTokens: [TokenType] = [
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
            case .equal, .notEqual, .greater, .less, .greaterEqual, .lessEqual:
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
                default:
                    fatalError("Invalid token type")
                }
            default:
                return result
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



class AssignmentVariable {
    private var variableIntMap: [String: String] = [:]

    init(_ variableIntMap: [String: String]) {
        self.variableIntMap.merge(variableIntMap){(_, new) in new}
    }
 
    public func setMapOfVariableInt(_ mapOfVariableInt: [String: String]) {
        self.variableIntMap.merge(mapOfVariableInt){(_, new) in new}
    }
 
    public func assign(_ variable: Variable) -> String {
        if variable.getType() == VariableType.int{

            return assignInt(variable.getValue())
        }
        return variable.getValue()    
    }

    private func assignInt(_ variable: String) -> String {
        let normalizedString = normalize(variable)
        let computedString = String(Calculate(normalizedString).compute())
        return computedString
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



class TreeNode{
    private(set) var value: String
    private(set) var type: AllTypes
    private(set) var parent: TreeNode?
    private(set) var children: [TreeNode]
    private(set) var countWasHere: Int

    internal  var dictionary: [String: String]


    init( _ value: String, _ type: AllTypes) {
        self.value = value
        self.type = type
        self.countWasHere = 0
        self.children = []
        self.dictionary = [:]
    }


    func addChild(_ child: TreeNode) {
        children.append(child)
        child.parent = self
        
        if child.type == .variable{
            dictionary[child.value] = ""
        }
    
        dictionary.merge(child.dictionary){(_, new) in new}
    }
}



class Interpreter{
    private(set) var treeAST: TreeNode

    init(_ treeAST: TreeNode){
        self.treeAST = treeAST
    }

    func traverseTree(_ treeAST: TreeNode) -> String{ 
        switch treeAST.type{
        case .variable:
            return processVariableNode(treeAST)
        case .arithmetic:
            return processArithmeticNode(treeAST)
        case .assign:
            processAssignNode(treeAST)
        case .root:
            processRootNode(treeAST)
        case .ifBlock:
            processIfBlockNode(treeAST)
        default:
            return "" // в этом случае нужно возвращать ID блока
        }
        return ""
    }
    private func processIfBlockNode(_ node: TreeNode){
        var tempDictionary: [String: String] = [:]
        if node.value != "0", node.value != ""{
            for child in node.children{
                let _ = traverseTree(child)
                for (key, value) in child.dictionary{
                    if node.dictionary[key] != "", node.dictionary[key] != Optional("")  {
                        node.dictionary[key] = value
                    } else{
                        tempDictionary.merge([key: value]){(_, new) in new}
                    }
                } 
                
            }
        }
        
        // print(String(describing: tempDictionary))
    }



    private func processRootNode(_ node: TreeNode){
        for child in node.children{
            
            let _ = traverseTree(child)
            for (key, value) in child.dictionary{
                    if value != "" && value != Optional("")  {
                        node.dictionary[key] = value
                    } else{
                        node.dictionary[key] = nil
                    }
                } 
            // node.dictionary.merge(child.dictionary){(_, new) in new}
            
        }
        print(node.dictionary)
    }

    private func processVariableNode(_ node: TreeNode) -> String{
        return node.value
    }

    private func processAssignNode(_ node: TreeNode){ 
    
        let varName = traverseTree(node.children[0])
        let assignValue = traverseTree(node.children[1])
        node.dictionary[varName] = assignValue
    }

    private func processArithmeticNode(_ node: TreeNode) -> String {
        return calculateArithmetic(node.value)
    }

    private func calculateArithmetic(_ expression: String) -> String {
        let variableForInt = Variable(
            id: 1,
            type: VariableType.int,
            value: expression
        )

        let mapElement = AssignmentVariable(self.treeAST.dictionary).assign(variableForInt)

        return mapElement
    }
}


let treeMain = TreeNode("", AllTypes.root)
let firstAssignSubtree = TreeNode("", AllTypes.assign)
let firstVarLeft = TreeNode("b", AllTypes.variable)
let firstVarRight = TreeNode("10", AllTypes.arithmetic)

let secondAssignSubtree = TreeNode("", AllTypes.assign)
let secondVarLeft = TreeNode("a", AllTypes.variable)
let secondVarRight = TreeNode("7 + b + 2", AllTypes.arithmetic)

let firstIfBlockSubtree = TreeNode("6 + 7", AllTypes.ifBlock)
let firstIfAssignSubtree = TreeNode("", AllTypes.assign)
let firstIfBlockVarLeft = TreeNode("c", AllTypes.variable)
let firstIfBlockVarRight = TreeNode("b", AllTypes.arithmetic)
// MAIN LOOP

firstAssignSubtree.addChild(firstVarLeft)
firstAssignSubtree.addChild(firstVarRight)

secondAssignSubtree.addChild(secondVarLeft)
secondAssignSubtree.addChild(secondVarRight)

firstIfAssignSubtree.addChild(firstIfBlockVarLeft)
firstIfAssignSubtree.addChild(firstIfBlockVarRight)
firstIfBlockSubtree.addChild(firstIfAssignSubtree)

treeMain.addChild(firstAssignSubtree)
treeMain.addChild(secondAssignSubtree)
treeMain.addChild(firstIfBlockSubtree)

// let interpreter = Interpreter(treeMain)
// let _ = interpreter.traverseTree(treeMain)



let condition1 = "a == 5"
let parser1 = ConditionParser(condition1)
let result1 = parser1.parse()
print(result1)
