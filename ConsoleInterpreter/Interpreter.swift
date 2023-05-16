import Foundation

protocol IBlock {

}

struct BlockDelimiter: IBlock {
    let type: DelimiterType
}

struct Condition: IBlock {
    let id: Int
    let type: ConditionType
    let value: String
}

struct Output: IBlock {
    let id: Int
    let value: String
}

struct Function: IBlock {
    let id: Int
    let value: String
}

struct Loop: IBlock {
    let id: Int
    let type: LoopType
    let value: String
}

struct Returning: IBlock {
    let id: Int
    let value: String
}

struct Variable: IBlock {
    let id: Int
    let type: VariableType
    let name: String
    let value: String
}

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

enum VariableType: String {
    case int
    case double
    case String
    case bool
    case another
    case array
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

enum AllTypes {
    case assign
    case ifBlock
    case elifBlock
    case elseBlock
    case loop
    case function
    case returnFunction
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
 
    public func normalize(_ variable: Variable) -> String {
        if variable.type == .int {
            return normalizeIntVariable(variable.value)
        } else if variable.type == .String {
            return normalizeStringVariable(variable.value)
        } else {
            fatalError("Invalid variable type")
        }
    }

    private func normalizeIntVariable(_ variable: String) -> String {

        let normalizedString = normalizeInt(variable)
        let computedString = String(Calculate(normalizedString).compare())
        return computedString
    }

    private func normalizeStringVariable(_ variable: String) -> String {
        let normalizedString = normalizeString(variable)
        return normalizedString
    }

    private func normalizeString(_ expression: String) -> String {
        var result = "" 
        let components = expression.split(whereSeparator: { $0 == " " })
        for component in components {
            if let value = variableMap[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }

    private func normalizeInt(_ expression: String) -> String {
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
        case .loop:
            processLoopNode(node)
        case .print:
            processPrintNode(node)
        default:
            return "" // в этом случае нужно возвращать ID блока
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
        let calculatedValue = calculateArithmetic(node.value)
        if let value = Int(calculatedValue) {
            printResult += "\(value)\n"
        } else {
            for dictionary in mapOfVariableStack.reversed(){
                if dictionary[node.value] != nil{
                    printResult += "\(dictionary[node.value]!)\n"
                    break;
                }
                if dictionary == mapOfVariableStack[0]{
                    fatalError("Variable \(node.value) not found")
                }
            }
        }
    }

    private func processVariableNode(_ node: Node) -> String{
        return node.value
    }

    private func processArithmeticNode(_ node: Node) -> String {
        if let intValue = Int(calculateArithmetic(node.value)) {
            return String(intValue)
        } else{
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
        
        let calculatedValue = calculateArithmetic(node.value)

        guard let value = Int(calculatedValue) else {
            fatalError("Invalid syntax")
        }
        if (value != 0 && node.getCountWasHere() == 0){
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
        let calculatedValue = calculateArithmetic(node.value)
        

        guard let value = Int(calculatedValue) else {
            fatalError("Invalid syntax")
        }

        if (value != 0 && node.getCountWasHere() == 0){
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

    private func processLoopNode(_ node: Node) {
        // "i = 0; i < 10; i = i + 1"
        guard let components = getLoopComponents(node.value) else {
            fatalError("Invalid syntax")
        }
        mapOfVariableStack.append([:])
        
        if components[0] != "" {
            let variableComponents = getInitializationComponents(components[0])

            let normalizedVariableValue = assignmentVariableInstance.normalize(
                Variable(
                    id: 1,
                    type: .int,
                    name: "loopValue",
                    value: variableComponents.value
                )
            )
            mapOfVariableStack[mapOfVariableStack.count - 1][variableComponents.name] = normalizedVariableValue

        } else if let variable = getConditionVariable(components[1]){

            for dictionary in mapOfVariableStack{
                if dictionary[variable] != nil {
                    mapOfVariableStack[mapOfVariableStack.count - 1][variable] = dictionary[variable]
                    break;
                }
            }
        }


        while Calculate(calculateArithmetic(components[1])).compare() == 1 {

            for child in node.children {
                if child.type == .ifBlock {
                    child.setCountWasHere(0)
                }
                let _ = traverseTree(child)
            }
            guard let variable = getStepComponents(components[2]) else{
                fatalError("Invalid syntax")
            }

            let assignValue = String(Calculate(calculateArithmetic(variable.value)).compare())

            if var lastDictionary = mapOfVariableStack.last {
                lastDictionary[variable.name] = assignValue
                mapOfVariableStack[mapOfVariableStack.count - 1] = lastDictionary
            }
        }
        
        if let lastDictionary = mapOfVariableStack.last {
            mapOfVariableStack.removeLast()
            updateMapOfStackFromLastDictionary(lastDictionary)
        }

        print("mapOfVariableStack = \(mapOfVariableStack)")
    }
 

    private func updateMapOfStackFromLastDictionary(_ lastDictionary: [String: String]){

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



    private func getLoopComponents(_ value: String) -> [String]? {
        let components = value.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 3 else {
            return nil
        }
        return components
    }
 
    private func getInitializationComponents(_ component: String) -> (name: String, value: String) {
        var isContain = 0
        if ["string","int"].contains(component) {
            isContain = 1
        }
        let variable = component.split(whereSeparator: { $0 == " " }).map{ $0.trimmingCharacters(in: .whitespaces) }

        if variable.count != 3 + isContain || variable[1 + isContain] != "=" {
            fatalError("Invalid syntax")
        }
        let variableName = variable[isContain]
        let variableValue = variable[2 + isContain]

        return (variableName, variableValue)
    }

    private func getConditionVariable(_ component: String) -> String? {
        let condition = component.split(separator: " ").map { $0.trimmingCharacters(in: .whitespaces) }
        guard condition.count == 3 && [">", "<", "==", ">=", "<="].contains(condition[1]) else {
            return nil
        }
        return condition[0]
    }

    private func getStepComponents(_ component: String) -> (name: String, value: String)? {
        for sign in ["++","--","+=","-=","*=","/=","%="]{
            if component.contains(sign){
                return getStepComponentsWithSign(component, sign)
            }
        }
        let components = component.split(separator: "=").map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard components.count == 2 else {
            return nil
        }
        let variableName = components[0]
        let variableValue = components[1]
        
        return (variableName, variableValue)
    }
    private func getStepComponentsWithSign(_ component: String, _ sign: String) -> (name: String, value: String)? {
        var components = component.split(separator: sign.first!).map { $0.trimmingCharacters(in: .whitespaces) }
        components[1].removeFirst()
        print("components = \(components)")
        guard components.count == 2 else {
            return nil
        }
        let variableName = components[0]
        let variableValue = components[1]
        
        return (variableName, variableValue)
    }
    private func calculateArithmetic(_ expression: String) -> String {
        var lastDictionary: [String: String] = [:]
        for dictionary in mapOfVariableStack {
            lastDictionary.merge(dictionary) { (_, new) in new }
        }
        assignmentVariableInstance.setMapOfVariable(lastDictionary)

        var variableForNormalize: Variable
        if let intValue = Int(expression){
            variableForNormalize = Variable(
                id: 1,
                type: VariableType.int,
                name: "temp",
                value: String(intValue)
            )
        } else {
            if isCondition(expression) != false {
                variableForNormalize = Variable(
                    id: 1,
                    type: VariableType.int,
                    name: "temp",
                    value: expression
                )
            } else {
                variableForNormalize = Variable(
                    id: 1,
                    type: VariableType.String,
                    name: "temp",
                    value: expression
                )
            }
        } 
        let mapElement = assignmentVariableInstance.normalize(variableForNormalize)
        for char in mapElement{
            if (char >= "a" && char <= "z") || (char >= "A" && char <= "Z") {
                return mapElement
            }
        }
        let calc = Calculate(mapElement).compare()
        return "\(calc)"
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
            case is Loop:
                if let loopNode = buildNode(getBlockAndMoveIndex(),
                        type: AllTypes.loop) {
                    rootNode.addChild(loopNode)
                }
            case is Condition:
                if let conditionNode = buildNode(getBlockAndMoveIndex(),
                        type: determineConditionBlock(block) ?? AllTypes.ifBlock) {
                    rootNode.addChild(conditionNode)
                }
            case is Function:
                if let functionNode = buildNode(getBlockAndMoveIndex(),
                        type: AllTypes.function) {
                    rootNode.addChild(functionNode)
                }
            case is BlockDelimiter:
                index += 1
            default:
                index += 1
            }
        }
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
                id: variable.id)
        let nameVariable = Node(value: variable.name, type: AllTypes.variable,
                id: variable.id)
        let valueVariable = Node(value: variable.value, type: AllTypes.arithmetic,
                id: variable.id)
        node.addChild(nameVariable)
        node.addChild(valueVariable)
        return node
    }


    private func buildPrintingNode(printing: Output) -> Node {
        let node = Node(value: printing.value, type: AllTypes.print,
                id: printing.id)
        return node
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


    private func buildNode(_ block: [IBlock], type: AllTypes) -> Node? {
        guard let firstBlock = block.first else {
            return nil
        }

        var node: Node?

        if type == AllTypes.ifBlock {
            guard let condition = firstBlock as? Condition else {
                return nil
            }
            node = Node(value: condition.value, type: AllTypes.ifBlock, id: condition.id)
        } else if type == AllTypes.elifBlock {
            guard let condition = firstBlock as? Condition else {
                return nil
            }
            node = Node(value: condition.value, type: AllTypes.elifBlock, id: condition.id)
        } else if type == AllTypes.elseBlock {
            guard let condtion = firstBlock as? Condition else {
                return nil
            }
            node = Node(value: condtion.value, type: AllTypes.elseBlock, id: condtion.id)
        }
        else if type == AllTypes.loop {
            guard let loop = firstBlock as? Loop else {
                return nil
            }
            node = Node(value: loop.value, type: type, id: loop.id)
        } else if type == AllTypes.function {
            guard let function = firstBlock as? Function else {
                return nil
            }
            node = Node(value: function.value, type: type, id: function.id)
        }

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
            } else if let returnBlock = block[index] as? Returning {
                let returnNode = Node(value: returnBlock.value,
                        type: .returnFunction, id: returnBlock.id)
                node?.addChild(returnNode)
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
                if let nestedNode = buildNode(nestedBlocks, type: .loop) {
                    node?.addChild(nestedNode)
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

// {
//    b = 10
//    a = 7 + b + 2 = 19
//    for(i = 0; i < 10; i++){
//        b = b + 10 = 20
//    }
//    if(a > 10){
//        b = b + 10 = 30
//    } else if(a > 5){
//        b = b + 20 = 50
//}
//    } else{
//        b = b + 30 = 50
//    }
//    print(b) = 210
// }

 
var array: [IBlock] = []

array.append(Variable(id: 0, type: .int, name: "b", value: "0"))
array.append(Variable(id: 1, type: .String, name: "a", value: "13"))

array.append(Loop(id: 3, type: .forLoop, value: "i = 0; i > -9; i = i - 1"))
array.append(BlockDelimiter(type: .begin))

array.append(Condition(id: 6,type: .ifBlock, value: "a >= -30"))
array.append(BlockDelimiter(type: .begin))
array.append(Variable(id: 8, type: .int, name: "b", value: "b + 100"))
array.append(Variable(id: 9, type: .int, name: "a", value: "a - 10"))

array.append(Output(id: 10, value: "a"))
array.append(BlockDelimiter(type: .end))


array.append(BlockDelimiter(type: .end))


let tree = Tree()
tree.setBlocks(array)
tree.buildTree()

let interpreter = Interpreter()
interpreter.setTreeAST(tree.rootNode)
print(interpreter.getPrintResult())
