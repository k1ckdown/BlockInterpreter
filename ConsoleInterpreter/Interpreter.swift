import Foundation

protocol IBlock {
}

struct BlockDelimiter: IBlock {
    let type: DelimiterType
}

struct Condition: IBlock {
    let isDebug: Bool
    let id: Int
    let type: ConditionType
    let value: String
}

struct Output: IBlock {
    let id: Int
    let value: String
    let isDebug: Bool
}

struct Function: IBlock {
    let id: Int
    let value: String
    let isDebug: Bool
}

struct Loop: IBlock {
    let id: Int
    let type: LoopType
    let value: String
    let isDebug: Bool
}

struct Returning: IBlock {
    let id: Int
    let value: String
    let isDebug: Bool
}

struct ReadingData: IBlock {
    let isDebug: Bool
    let id: Int
    let value: String
}

struct Variable: IBlock {
    let id: Int
    let type: VariableType
    let name: String
    let value: String
    let isDebug: Bool
}

struct Break: IBlock {
    let isDebug: Bool
    let id: Int
    let value: String
}

struct Continue: IBlock {
    let id: Int
    let value: String
    let isDebug: Bool
}

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

enum DelimiterType {
    case begin
    case end
}

enum LoopType {
    case forLoop
    case whileLoop
}

enum ConditionType: String, CaseIterable {
    case ifBlock, elifBlock, elseBlock

    var name: String {
        switch self {
        case .ifBlock:
            return "if"
        case .elifBlock:
            return "elif"
        case .elseBlock:
            return "else"
        }
    }
}

enum AllTypes: Equatable {
    case assign
    case ifBlock
    case elifBlock
    case elseBlock
    case forLoop
    case whileLoop
    case function
    case returnFunction
    case variable
    case arithmetic(type: VariableType)
    case print
    case root
    case breakBlock
    case continueBlock
    case cin

    static func ==(lhs: AllTypes, rhs: AllTypes) -> Bool {
        switch (lhs, rhs) {
        case (.assign, .assign):
            return true
        case (.ifBlock, .ifBlock):
            return true
        case (.elifBlock, .elifBlock):
            return true
        case (.elseBlock, .elseBlock):
            return true
        case (.forLoop, .forLoop):
            return true
        case (.whileLoop, .whileLoop):
            return true
        case (.function, .function):
            return true
        case (.returnFunction, .returnFunction):
            return true
        case (.variable, .variable):
            return  true
        case (.arithmetic(_), .arithmetic(_)):
            return true
        case (.print, .print):
            return true
        case (.root, .root):
            return true
        case (.breakBlock, .breakBlock):
            return true
        case (.continueBlock, .continueBlock):
            return true
        case (.cin, .cin):
            return true
        default:
            return false
        }
    }
}


enum VariableType: String {
    case int
    case double
    case String
    case bool
    case another
    case array
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
            let unpossibleSymbols: [Character] = [
                " ", "+", "-", "*", "/", "%", "(", ")", "=", "<", ">", "!", "&", "|"
            ]
            while position < text.count {
                let nextChar = text[text.index(text.startIndex, offsetBy: position)]
                if isChar(nextChar) || isNumber(nextChar) || !unpossibleSymbols.contains(nextChar) {
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





class Node {
    private(set) var value: String
    private(set) var type: AllTypes
    private(set) var parent: Node?
    private(set) var children: [Node]
    private var countWasHere: Int
    private(set) var id: Int
    private(set) var isDebug: Bool

    init(value: String, type: AllTypes, id: Int, isDebug: Bool = false) {
        self.value = value
        self.type = type
        self.id = id
        self.isDebug = isDebug
        countWasHere = 0
        children = []
    }

    func addChild(_ child: Node) {
        children.append(child)
        child.parent = self
    }
    func getCountWasHere() -> Int {
        return countWasHere
    }
    func setCountWasHere(_ countWasHere: Int) {
        self.countWasHere = countWasHere
    }
}



class StringNormalizer {
    private var variableMap: [String: String]

    init(_ variableMap: [String: String]) {
        self.variableMap = variableMap
    }
 
    public func setMapOfVariable(_ mapOfVariable: [String: String]) {
        self.variableMap.merge(mapOfVariable){(_, new) in new}
    }

 
    public func normalize(_ expression: String) -> String {
        return normalizeString(expression)
    }


    private func normalizeString(_ expression: String) -> String {
        var result = "" 
        let updatedExpression = getFixedString(expression)
        let components = updatedExpression.split(whereSeparator: { $0 == " " })
        for component in components {
            if let intValue = Int(component) {
                result += "\(intValue)"
            } else if let value = variableMap[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }

    private func getFixedString(_ expression: String) -> String{

        let signsForReplacing = ["++","--","+=","-=","*=","/=","%="]
        for sign in signsForReplacing{
            if expression.contains(sign){
                return replaceSigns(expression, sign)
            }
        }

        return addWhitespaces(expression)
    }

    private func replaceSigns(_ expression: String, _ sign: String) -> String{
        var updatedExpression = ""
        if expression.contains("++"){
            let str = expression.split(separator: "+")
            updatedExpression += "\(str[0]) = \(str[0]) + 1"
        } else if expression.contains("--"){
            let str = expression.split(separator: "-")
            updatedExpression += "\(str[0]) = \(str[0]) - 1"
        } else {
            var str = expression.split(separator: sign.first!)
            str[1].removeFirst()
            updatedExpression += "\(str[0]) = \(str[0]) \(sign.first!) \(str[1])"
            if str.count > 2 {
                for i in 2..<str.count{
                    updatedExpression += " \(sign.first!) \(str[i])"
                }
            }
        }

        return updatedExpression
    }
    
    private func addWhitespaces(_ expression: String ) -> String{

        let arithmeticSigns = ["+","*", "/", "%", "(", ")", "-", "=", "<", ">"]
        let doubleArithmeticSigns = ["==", "!=", "<=", ">=", "&&", "||"]

        var index = 0
        var updatedExpression = ""

        while index < expression.count{
            let char = expression[expression.index(expression.startIndex, offsetBy: index)]
            if index + 1 < expression.count - 1 && doubleArithmeticSigns.contains("\(char)\(expression[expression.index(expression.startIndex, offsetBy: index + 1)])"){
                updatedExpression += " \(char)\(expression[expression.index(expression.startIndex, offsetBy: index + 1)]) "
                index += 1
            } else if char == "-" , index + 1 < expression.count - 1, isNumber(expression[expression.index(expression.startIndex, offsetBy: index + 1)]) {
                updatedExpression += " \(char)"
            }else if arithmeticSigns.contains(String(char)){
                updatedExpression += " \(char) "
            } else {
                updatedExpression += "\(char)"
            }
            index += 1
        }

        return updatedExpression
    }

    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
}

class ExpressionSolver{
    private var expression: String
    private var type: VariableType
    public var solvedExpression: String

    init(_ expression: String, _ type: VariableType) {
        self.expression = expression
        self.type = type
        self.solvedExpression = ""
        updateSolvedExpression()
    }

    private func updateSolvedExpression(){
        let calculate = Calculate("")

        if type == .String {
            let updatedExpression = expression.replacingOccurrences(of: "“", with: "").replacingOccurrences(of: "”", with: "")
            calculate.setText(text: updatedExpression)
            let calculatedValue = calculate.compareString()
            if expression.contains("“") && expression.contains("”") && calculatedValue != "false" && calculatedValue != "true"{
                self.solvedExpression = "“" +  calculatedValue + "”"
            } else {
                self.solvedExpression = calculatedValue
            }
        } else {
            calculate.setText(text: expression)
            let calculatedValue = calculate.compare()

            if type == .int {
                self.solvedExpression =  String(calculatedValue)
            } else if type == .double {
                self.solvedExpression = String(Double(calculatedValue))
            } else if type == .bool {
                self.solvedExpression = calculatedValue == 0 ? "false" : "true"
            } else {
                self.solvedExpression =  ""
            }
        }
    }
}

class Interpreter {
    private var treeAST: Node
    internal var mapOfVariableStack = [[String: String]]()
    private var assignmentVariableInstance = StringNormalizer([:])
    private var printResult = ""

    init() {
        treeAST = Node(value: "", type: .root, id: 0)
        
    }
    
    func setTreeAST(_ treeAST: Node){
        printResult = ""
        self.treeAST = treeAST
        self.mapOfVariableStack = [[String: String]]()
        self.assignmentVariableInstance = .init([:])
        mapOfVariableStack.removeAll()
        let _ = traverseTree(treeAST)
    }
    
    func getPrintResult() -> String {
        return printResult
    }
    
    func traverseTree(_ node: Node) -> String { 
        switch node.type{
        case .variable:
            return processVariableNode(node)
        case .arithmetic:
            return processArithmeticNode(node)
        case .assign:
            processAssignNode(node)
        case .root:
            processRootNode(node)
        case .ifBlock:
            processIfBlockNode(node)
        case .elifBlock:
            processElifBlockNode(node)
        case .elseBlock:
            processElseBlockNode(node)
        case .whileLoop:
            processWhileLoopNode(node)
        case .forLoop:
            processForLoopNode(node)
        case .print:
            processPrintNode(node)
        default:
            return ""
        }
         
        return ""
    }
    
    private func processRootNode(_ node: Node){
        mapOfVariableStack.append([:])
        for child in node.children{
            let _ = traverseTree(child)
            while mapOfVariableStack.count > 1 {
                mapOfVariableStack.removeLast()
            }
        } 
        print(mapOfVariableStack, "mapOfVariableStack")
    }

    private func processPrintNode(_ node: Node){
        let components = getPrintValues(node.value)

        for component in components{
            if component.contains("“") && component.contains("”"){
                printResult += "\(component) "
            } else if component.contains("“") || component.contains("”"){
                fatalError("Invalid syntax")
            } else {
                let calculatedValue = calculateArithmetic(component, .String)

                printResult += "\(calculatedValue) "
            }
        }

    }

    private func getPrintValues(_ expression: String) -> [String]{
        var result = [String]()
        var index = 0
        var currentString = ""
        var inQuotes = false
        while index < expression.count{
            let char = expression[expression.index(expression.startIndex, offsetBy: index)]
            if char == "“" || char == "”"{
                inQuotes = !inQuotes
            } else if char == "," && !inQuotes{
                result.append(currentString)
                currentString = ""
            } else {
                currentString += "\(char)"
            }
            index += 1
        }
        if currentString != ""{
            result.append(currentString)
        }
        return result
    }

    private func processVariableNode(_ node: Node) -> String{
        return node.value
    }

    private func processArithmeticNode(_ node: Node) -> String {
        switch node.type {
        case .arithmetic(let type):
            let value = calculateArithmetic(node.value, type)

            if let intValue = Int(value) {
                return String(intValue)
            } else {
                return value
            }
        default:
            return node.value
        }
    }

    private func processAssignNode(_ node: Node){

        let varName = traverseTree(node.children[0])
        let assignValue = traverseTree(node.children[1])
        if var lastDictionary = mapOfVariableStack.last {
            lastDictionary[varName] = assignValue
            mapOfVariableStack[mapOfVariableStack.count - 1] = lastDictionary
        }
    }

    private func processIfBlockNode(_ node: Node){ 
        
        let calculatedValue = calculateArithmetic(node.value, .bool)
        if (calculatedValue == "true" && node.getCountWasHere() == 0){
            handleIfBlockNode(node) 
            node.setCountWasHere(1)
        } else{
            node.setCountWasHere(0)
        }
    }

    private func handleIfBlockNode(_ node: Node){
        mapOfVariableStack.append([:])

        for child in node.children{
            let _ = traverseTree(child)

            if child.type == .ifBlock {
                mapOfVariableStack.append([:])
            }

            if let lastDictionary = mapOfVariableStack.last {
                mapOfVariableStack.removeLast()
                updateMapOfStackFromLastDictionary(lastDictionary)
            }

        } 
    }

    private func processElifBlockNode(_ node: Node){
        let calculatedValue = calculateArithmetic(node.value, .bool)
        
        if (calculatedValue == "true" && node.getCountWasHere() == 0){
            handleIfBlockNode(node) 
            node.setCountWasHere(1)
        } else{
            node.setCountWasHere(0)
        }
    }

    private func processElseBlockNode(_ node: Node){
        if (node.getCountWasHere() == 0){
            handleIfBlockNode(node) 
        }
    }

    private func processWhileLoopNode(_ node: Node){

        let condition = node.value

        if condition == "" {
            fatalError("Invalid syntax")
        }

        mapOfVariableStack.append([:])

        while calculateArithmetic(node.value, .bool) == "true" { //* изменить на сравнение с true

            for child in node.children {
                if child.type == .ifBlock {
                    child.setCountWasHere(0)
                    let _ = traverseTree(child)

                } else{
                    let _ = traverseTree(child)
                }  
            }

        }
        
        if let lastDictionary = mapOfVariableStack.last {
            mapOfVariableStack.removeLast()
            updateMapOfStackFromLastDictionary(lastDictionary)
        }


    }

    private func processForLoopNode(_ node: Node) {
        guard let components = getForLoopComponents(node.value) else {
            fatalError("Invalid syntax")
        }
        mapOfVariableStack.append([:])
        
        if components[0] != "" {
            let variableComponents = getForLoopInitializationComponents(components[0])
            if variableComponents.name == "" || variableComponents.value == "" {
                fatalError("Invalid syntax")
            }
            var isThereVariable = false
            for dictionary in mapOfVariableStack{
                if dictionary[variableComponents.name] != nil {
                    isThereVariable = true
                    break;
                }
            } 
            if isThereVariable && variableComponents.wasInitialized == 1 {
                fatalError("Variable already exists")
            } else if !isThereVariable && variableComponents.wasInitialized == 0{
                fatalError("Variable not found")
            }

            let normalizedVariableValue = assignmentVariableInstance.normalize(variableComponents.value)
            mapOfVariableStack[mapOfVariableStack.count - 1][variableComponents.name] = normalizedVariableValue

        } else if let variable = getConditionVariable(components[1]){

            for dictionary in mapOfVariableStack{
                if dictionary[variable] != nil {
                    mapOfVariableStack[mapOfVariableStack.count - 1][variable] = dictionary[variable]
                    break;
                }
            }
            if mapOfVariableStack[mapOfVariableStack.count - 1][variable] == nil {
                fatalError("Variable not found")
            }
        }


        while calculateArithmetic(components[1], .bool) == "true" { //* изменить на сравнение с true

            for child in node.children {
                if child.type == .ifBlock {
                    child.setCountWasHere(0)
                }
                let _ = traverseTree(child)
            }
            guard let variable = getStepComponents(components[2]) else{
                fatalError("Invalid syntax")
            }

            let assignValue = String(calculateArithmetic(variable.value, .int))

            if var lastDictionary = mapOfVariableStack.last {
                lastDictionary[variable.name] = assignValue
                mapOfVariableStack[mapOfVariableStack.count - 1] = lastDictionary
            }
        }
        
        if let lastDictionary = mapOfVariableStack.last {
            mapOfVariableStack.removeLast()
            updateMapOfStackFromLastDictionary(lastDictionary)
        }

    }
 
    private func updateMapOfStackFromLastDictionary(_ lastDictionary: [String: String]){
        if mapOfVariableStack.count == 0 {
            mapOfVariableStack.append(lastDictionary)
        } else{
            for (key, value) in lastDictionary {
                for index in (0..<mapOfVariableStack.count).reversed() {
                    var dictionary = mapOfVariableStack[index]
                    if dictionary[key] != nil {
                        dictionary[key] = String(value)
                        mapOfVariableStack[index][key] = value       
                        break
                    } else if index == 0{
                        mapOfVariableStack.append([:])
                        mapOfVariableStack[mapOfVariableStack.count - 1][key] = value
                    }
                }
            }
        }
  
    }

    private func getForLoopComponents(_ value: String) -> [String]? {
        let components = value.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 3 else {
            return nil
        }
        return components
    }

    private func getForLoopInitializationComponents(_ component: String) -> (name: String, value: String, wasInitialized: Int) {
        var wasInitialized = 0
        if component.contains("int") || component.contains("string") {
            wasInitialized = 1
        }
        let variable = component.split(whereSeparator: { $0 == " " }).map{ $0.trimmingCharacters(in: .whitespaces) }
        if variable.count != 3 + wasInitialized || variable[1 + wasInitialized] != "=" {
            fatalError("Invalid syntax")
        }
        let variableName = variable[wasInitialized]
        let variableValue = variable[2 + wasInitialized]
        return (variableName, variableValue, wasInitialized)
    }

    private func getConditionVariable(_ component: String) -> String? {
        let condition = component.split(separator: " ").map { $0.trimmingCharacters(in: .whitespaces) }
        guard condition.count == 3 && [">", "<", "==", ">=", "<="].contains(condition[1]) else {
            return nil
        }
        return condition[0]
    }

    private func getStepComponents(_ component: String) -> (name: String, value: String)? {
        var parseString = component
        for sign in ["++","--","+=","-=","*=","/=","%="]{
            if parseString.contains(sign){
                parseString =  getUpdatedString(parseString, sign)
            }
        }
        let components = parseString.split(separator: "=").map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard components.count == 2 else {
            return nil
        }
        let variableName = components[0]
        let variableValue = components[1]
        
        return (variableName, variableValue)
    }

    private func getUpdatedString(_ expression: String, _ sign: String) -> String {

        var updatedExpression = ""

        if expression.contains("++"){
            let str = expression.split(separator: "+")
            updatedExpression += "\(str[0]) = \(str[0]) + 1"
        } else if expression.contains("--"){
            let str = expression.split(separator: "-")
            updatedExpression += "\(str[0]) = \(str[0]) - 1"
        } else {
            var str = expression.split(separator: sign.first!)
            str[1].removeFirst()
            updatedExpression += "\(str[0]) = \(str[0]) \(sign.first!) \(str[1])"
            if str.count > 2 {
                for i in 2..<str.count{
                    updatedExpression += " \(sign.first!) \(str[i])"
                }
            }
        }
        return updatedExpression

    }

    private func calculateArithmetic(_ expression: String, _ type: VariableType) -> String {
        var lastDictionary: [String: String] = [:]

        for dictionary in mapOfVariableStack {
            lastDictionary.merge(dictionary) { (_, new) in new }
        }
        assignmentVariableInstance.setMapOfVariable(lastDictionary)

        let mapElement = assignmentVariableInstance.normalize(expression)
        let calcValue = ExpressionSolver(mapElement, type).solvedExpression

        return calcValue
    }

    private func isCondition(_ expression: String) -> Bool {
        let letters = #"([a-zA-Z]+\w*)"#
        let digits = #"((0)|(\-?[\d]+))"#
        
        let incrimentOrDicrimentSymbols = #"((\+\+)|(\-\-))"#
        let incrimentOrDicriment = #"^\s*\s*((\#(letters)\#(incrimentOrDicrimentSymbols))|(\#(incrimentOrDicrimentSymbols)\#(letters)))\s*$"#
        let reg = #"^\s*(\#(incrimentOrDicriment))|(\#(letters)(\[\s*(\#(letters)|\#(digits))\s*\])?\s*[\+\-\*\/\%]?[\+\-\/\*\%]\s*((\#(letters)((\[\s*(\#(letters)|\#(digits))\s*\])|(\(\s*(\#(letters)|\#(digits))\s*\)))?)|\#(digits))(\s*([\+\-\*\/]|(\=\=))\s*((\#(letters)((\[\s*(\#(letters)|\#(digits))\s*\])|(\(\s*(\#(letters)|\#(digits))\s*\)))?)|\#(digits)))*)\s*$"#
        let binReg = #"^\(?((\#(letters)((\[\s*(\#(letters)|\#(digits))\s*\])|(\(\s*(\#(letters)|\#(digits))\s*\)))?)|\#(digits))\s*\)?(\s*((\|\|)|(\&\&)|(\<\=?)|(\>\=?)|(\!\=)|(\=\=))\s*((\#(letters)((\[\s*(\#(letters)|\#(digits))\s*\])|(\(\s*(\#(letters)|\#(digits))\s*\)))?)|\#(digits)))*$"#
        let regularValue = #"^\s*(\#(reg))\s*|\s*(\#(binReg))\s*$"#
        let arithmeticRegex = try! NSRegularExpression(pattern: regularValue, options: [])
        let isCondition = arithmeticRegex.firstMatch(in: expression, options: [], range: NSRange(location: 0, length: expression.utf16.count)) != nil
        return isCondition
    }
}
//“ ”



class Tree {
    var rootNode: Node = Node(value: "", type: AllTypes.root, id: 0)
    var index: Int = 0
    var blocks = [IBlock]()

    init() {

    }

    func setBlocks(_ blocks: [IBlock]) {
        self.blocks = blocks
    }

    func buildTree() {
        while index < blocks.count {
            let block = blocks[index]
            switch block {
            case let variableBlock as Variable:
                let variableNode = buildVariableNode(variable: variableBlock)
                rootNode.addChild(variableNode)
                index += 1
            case let printBlock as Output:
                let printingNode = buildPrintingNode(printing: printBlock)
                rootNode.addChild(printingNode)
                index += 1
            case let readBlock as ReadingData:
                let readingNode = buildReadingNode(reading: readBlock)
                rootNode.addChild(readingNode)
                index += 1
            case is Loop:
                if let loopNode = buildNode(getBlockAndMoveIndex(),
                        type: determineLoopBlock(block) ?? AllTypes.forLoop) {
                    rootNode.addChild(loopNode)
                }

            case is Condition:
                if let conditionNode = buildNode(getBlockAndMoveIndex(),
                        type: determineConditionBlock(block) ?? AllTypes.ifBlock) {
                    rootNode.addChild(conditionNode)
                }
            case is BlockDelimiter:
                index += 1
            case is Function:
                if let functionNode = buildNode(getBlockAndMoveIndex(),
                        type: AllTypes.function) {
                    rootNode.addChild(functionNode)
                }
            case is Break:
                if let breakNode = buildBreak(block) {
                    rootNode.addChild(breakNode)
                }
                index += 1
            case is Continue:
                if let continueNode = buildContinue(block) {
                    rootNode.addChild(continueNode)
                }
                index += 1
            default:
                index += 1

            }
        }
    }

    private func buildReadingNode(reading: ReadingData) -> Node {
        let node = Node(value: reading.value, type: AllTypes.cin,
                id: reading.id, isDebug: reading.isDebug)
        return node
    }

    private func buildBreak(_ block: IBlock) -> Node? {
        if let breakBlock = block as? Break {
            let node = Node(value: breakBlock.value, type: AllTypes.breakBlock,
                    id: breakBlock.id, isDebug: breakBlock.isDebug)
            return node
        }
        return nil
    }

    private func buildContinue(_ block: IBlock) -> Node? {
        if let continueBlock = block as? Continue {
            let node = Node(value: continueBlock.value, type: AllTypes.continueBlock,
                    id: continueBlock.id, isDebug: continueBlock.isDebug)
            return node
        }
        return nil
    }

    private func getMatchingDelimiterIndex() -> Int? {
        var countBegin = 0
        for i in (index + 1)..<blocks.count {
            guard let block = blocks[i] as? BlockDelimiter else {
                continue
            }
            countBegin += countForMatchingDelimiter(block)
            if countBegin == 0 {
                return i
            }
        }
        return nil
    }

    private func countForMatchingDelimiter(_ block: BlockDelimiter) -> Int {
        if isEndDelimiter(block) {
            return -1
        } else if isBeginDelimiter(block) {
            return 1
        }
        return 0
    }

    private func isBeginDelimiter(_ block: BlockDelimiter) -> Bool {
        block.type == DelimiterType.begin
    }

    private func isEndDelimiter(_ block: BlockDelimiter) -> Bool {
        block.type == DelimiterType.end
    }


    private func getBlockAndMoveIndex() -> [IBlock] {
        var wholeBlock: [IBlock] = []
        guard let endIndex = getMatchingDelimiterIndex() else {
            return wholeBlock
        }
        wholeBlock.append(blocks[index])
        wholeBlock += Array(blocks[(index + 1)...endIndex])
        index = endIndex + 1
        return wholeBlock
    }

    private func buildVariableNode(variable: Variable) -> Node {
        let node = Node(value: variable.type.rawValue, type: AllTypes.assign,
                id: variable.id, isDebug: variable.isDebug)
        let nameVariable = Node(value: variable.name, type: AllTypes.variable,
                id: variable.id)
        let valueVariable = Node(value: variable.value, type: AllTypes.arithmetic(type: variable.type),
                id: variable.id)
        node.addChild(nameVariable)
        node.addChild(valueVariable)
        return node
    }


    private func buildPrintingNode(printing: Output) -> Node {
        let node = Node(value: printing.value, type: AllTypes.print,
                id: printing.id, isDebug: printing.isDebug)
        return node
    }

    private func determineLoopBlock(_ block: IBlock) -> AllTypes? {
        if let loop = block as? Loop {
            if loop.type == LoopType.forLoop {
                return AllTypes.forLoop
            } else if loop.type == LoopType.whileLoop {
                return AllTypes.whileLoop
            }
        }
        return nil
    }

    private func determineConditionBlock(_ block: IBlock) -> AllTypes? {
        if let condition = block as? Condition {
            if condition.type == ConditionType.ifBlock {
                return AllTypes.ifBlock
            } else if condition.type == ConditionType.elifBlock {
                return AllTypes.elifBlock
            } else if condition.type == ConditionType.elseBlock {
                return AllTypes.elseBlock
            }
        }
        return nil
    }

    private func buildFirstNode(_ type: AllTypes,
                                _ firstBlock: IBlock) -> Node? {
        var node: Node?
        if type == AllTypes.ifBlock {
            guard let condition = firstBlock as? Condition else {
                return nil
            }
            node = Node(value: condition.value, type: AllTypes.ifBlock,
                    id: condition.id, isDebug: condition.isDebug)
        } else if type == AllTypes.elifBlock {
            guard let condition = firstBlock as? Condition else {
                return nil
            }
            node = Node(value: condition.value, type: AllTypes.elifBlock,
                    id: condition.id, isDebug: condition.isDebug)
        } else if type == AllTypes.elseBlock {
            guard let condtion = firstBlock as? Condition else {
                return nil
            }
            node = Node(value: condtion.value, type: AllTypes.elseBlock,
                    id: condtion.id, isDebug: condtion.isDebug)
        }
        else if type == AllTypes.forLoop || type == AllTypes.whileLoop {
            guard let loop = firstBlock as? Loop else {
                return nil
            }
            node = Node(value: loop.value, type: type,
                    id: loop.id, isDebug: loop.isDebug)
        } else if type == AllTypes.function {
            guard let function = firstBlock as? Function else {
                return nil
            }
            node = Node(value: function.value, type: type,
                    id: function.id, isDebug: function.isDebug)
        }
        return node
    }


    private func buildNode(_ block: [IBlock], type: AllTypes) -> Node? {
        guard let firstBlock = block.first else {
            return nil
        }

        let node = buildFirstNode(type, firstBlock)
        var index = 1

        while index < block.count {
            if block[index] is BlockDelimiter {
                index += 1
                continue
            } else if let variableBlock = block[index] as? Variable {
                let variableNode = buildVariableNode(variable: variableBlock)
                node?.addChild(variableNode)
            } else if let printBlock = block[index] as? Output {
                let printingNode = buildPrintingNode(printing: printBlock)
                node?.addChild(printingNode)
            } else if let readingDataBlock = block[index] as? ReadingData {
                let readingDataNode = Node(value: readingDataBlock.value,
                        type: .cin, id: readingDataBlock.id,
                        isDebug: readingDataBlock.isDebug)
                node?.addChild(readingDataNode)
            } else if let returnBlock = block[index] as? Returning {
                let returnNode = Node(value: returnBlock.value,
                        type: .returnFunction, id: returnBlock.id,
                        isDebug: returnBlock.isDebug)
                node?.addChild(returnNode)
            } else if let continueBlock = block[index] as? Continue {
                let continueNode = Node(value: continueBlock.value,
                        type: .continueBlock, id: continueBlock.id,
                        isDebug: continueBlock.isDebug)
                node?.addChild(continueNode)
            } else if let breakBlock = block[index] as? Break {
                let breakNode = Node(value: breakBlock.value,
                        type: .breakBlock, id: breakBlock.id,
                        isDebug: breakBlock.isDebug)
                node?.addChild(breakNode)
            } else if let nestedConditionBlock = block[index] as? Condition {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedConditionBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? BlockDelimiter {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let typeCondition = determineConditionBlock(nestedConditionBlock) {
                    if let nestedNode = buildNode(nestedBlocks, type: typeCondition) {
                        node?.addChild(nestedNode)
                    }
                }

                index = additionIndex
            } else if let nestedLoopBlock = block[index] as? Loop {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedLoopBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? BlockDelimiter {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let typeLoop = determineLoopBlock(nestedLoopBlock) {
                    if let nestedNode = buildNode(nestedBlocks, type: typeLoop) {
                        node?.addChild(nestedNode)
                    }
               }
                index = additionIndex
            } else if let nestedFunctionBlock = block[index] as? Function {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedFunctionBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? BlockDelimiter {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildNode(nestedBlocks, type: .function) {
                    node?.addChild(nestedNode)
                }
                index = additionIndex
            }
            index += 1
        }
        return node
    }
}




 
var array: [IBlock] = []

array.append(Variable(id: 0, type: .int, name: "b", value: "10", isDebug: false))
array.append(Variable(id: 1, type: .String, name: "a", value: "“abc”", isDebug: false))
// array.append(Variable(id: 9, type: .String, name: "a", value: "a + “abc”", isDebug: false))

array.append(Loop(id: 3, type: .forLoop, value: "int i = 0; i < 10; i += 3", isDebug: false))
array.append(BlockDelimiter(type: .begin))
// array.append(Variable(id: 9, type: .String, name: "a", value: "a + “abc”", isDebug: false))
array.append(Output(id: 10, value: "a == “abc”", isDebug: false))


array.append(BlockDelimiter(type: .end))


array.append(BlockDelimiter(type: .end))


let tree = Tree()
tree.setBlocks(array)
tree.buildTree()

let interpreter = Interpreter()
interpreter.setTreeAST(tree.rootNode)
print(interpreter.getPrintResult())


//“ ”


