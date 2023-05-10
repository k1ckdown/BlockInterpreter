
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
    case logicalAnd
    case logicalOr
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
        while let token = self.currentToken, possibleTokens.contains(token.getType()) {
            
            if token.getType() == .plus {
                moveToken(.plus)
                result += term()
            } else if token.getType() == .minus {
                moveToken(.minus)
                result -= term()
            } else if possibleTokens.contains(token.getType()){
                self.moveToken(token.getType())
                let factorValue = self.factor()

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
        var result = self.factor()
        let possibleTokens: [TokenType] = [
            TokenType.modulo,
            TokenType.multiply,
            TokenType.divide,
        ]
        if self.currentToken == nil {
            return result
        }
        while let token = self.currentToken, possibleTokens.contains(token.getType()){
            switch token.getType() {
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

        switch token.getType() {
            case .integer:
                self.moveToken(.integer)
                guard let value = token.getValue(), let intValue =
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
                print(token.getType())
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
        let computedString = String(Calculate(normalizedString).compare())
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
        let calculator = Calculate(node.value)
        let value = calculator.compare()
        if value != 0{
            for child in node.children{
                let _ = traverseTree(child)
                for (key, value) in child.dictionary{
                    // print(node.dictionary)
                    // print(key, value, node.dictionary[key] != nil, node.dictionary[key] != "", node.dictionary[key] != Optional(""))
                    if node.dictionary[key] == "" || node.dictionary[key] == Optional("") {
                        node.dictionary[key] = value
                        tempDictionary.merge([key: value]){(_, new) in new}
                    } else{
                        node.dictionary[key] = nil
                        tempDictionary.merge([key: value]){(_, new) in new}
                    }
                } 
                
            }
        }
        // print(node.dictionary, "node")
        // print(tempDictionary, "temp")
    }



    private func processRootNode(_ node: TreeNode){
        // print(node.dictionary)
        for child in node.children{
            let _ = traverseTree(child)
            
            node.dictionary.merge(child.dictionary){(_, new) in new}
            // for (key, value) in child.dictionary{
            //         // print(key, value)
            //         if value != "" && value != Optional("") && value != nil  {
            //             node.dictionary[key] = value
            //         } else{
            //             node.dictionary[key] = nil
            //         }
            //     } 
            
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
let firstVarRight = TreeNode("10", AllTypes.arithmetic) // присваиваем значение 10 переменной b

let secondAssignSubtree = TreeNode("", AllTypes.assign)
let secondVarLeft = TreeNode("a", AllTypes.variable)
let secondVarRight = TreeNode("7 + b + 2", AllTypes.arithmetic) // присваиваем значение 7 + b + 2 переменной a

let firstIfBlockSubtree = TreeNode("(6 + 2) % 8 == 0", AllTypes.ifBlock) // условие для if

let firstIfAssignSubtree = TreeNode("", AllTypes.assign) 
let firstIfBlockVarLeft = TreeNode("c", AllTypes.variable) // присваиваем значение 110 переменной b
let firstIfBlockVarRight = TreeNode("b + 100", AllTypes.arithmetic)


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
// treeMain.addChild(secondIfBlockSubtree)

let interpreter = Interpreter(treeMain)
let _ = interpreter.traverseTree(treeMain)


