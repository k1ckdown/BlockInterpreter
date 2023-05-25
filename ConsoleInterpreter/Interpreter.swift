import Foundation

// struct ConsoleOutput{
//     outputValue: String;
//     errorDictionary: [Int: ErrorType]
// }


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
    case leftQuote
    case rightQuote
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
    case variable(type: VariableType)
    case arithmetic
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
        case (.variable(_), .variable(_)):
            return  true
        case (.arithmetic, .arithmetic):
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
        let nameVariable = Node(value: variable.name, type: .variable(type: variable.type),
                id: variable.id)
        let valueVariable = Node(value: variable.value, type: AllTypes.arithmetic,
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
        if let condition = firstBlock as? Condition {
            switch type {
            case .ifBlock:
                node = Node(value: condition.value, type: .ifBlock, id: condition.id, isDebug: condition.isDebug)
            case .elifBlock:
                node = Node(value: condition.value, type: .elifBlock, id: condition.id, isDebug: condition.isDebug)
            case .elseBlock:
                node = Node(value: condition.value, type: .elseBlock, id: condition.id, isDebug: condition.isDebug)
            default:
                return nil
            }
        } else if let loop = firstBlock as? Loop {
            if type == .forLoop || type == .whileLoop {
                node = Node(value: loop.value, type: type, id: loop.id, isDebug: loop.isDebug)
            } else {
                return nil
            }
        } else if let function = firstBlock as? Function {
            if type == .function {
                node = Node(value: function.value, type: type, id: function.id, isDebug: function.isDebug)
            } else {
                return nil
            }
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
        guard let token = currentToken else{
            fatalError("Current token is nil")
        }

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
            print(token.getType(), text)
            fatalError("Invalid syntax")
        }
    }

    public func compareString() -> String{
        currentToken = getNextToken() 
        var result = ""
        result += termString()

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
                moveToken(.leftQuote)
                result += termString()
            } else if token.getType() == .rightQuote {
                moveToken(.rightQuote)
                result += termString()
            } else if token.getType() == .plus {
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
        if currentToken == nil {
            return result
        }
        while let token = currentToken, token.getType() == .multiply {
            switch token.getType() {
            case .multiply:
                moveToken(.multiply)
                let factorValue = factorString()
                guard let firstChar = factorValue.first else{
                    fatalError("Symbol after * is not found")
                }
                if !isNumber(firstChar){
                    fatalError("Invalid syntax")
                }
                let oldResult = result
                if let factorValue = Int(String(firstChar)){
                    result = ""
                    for _ in 0..<factorValue - 1{
                        result += oldResult
                    }
                } else {
                    fatalError("Value after * is not a number")
                }

            default:
                fatalError("Invalid token type")
            }
        }
        return result
    }

    private func factorString() -> String {
        guard let token = currentToken else{
            fatalError("Current token is nil")
        }

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
        case .eof:
            moveToken(.eof)
            return token.getValue() ?? ""
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
            var nextChar = text[text.index(text.startIndex, offsetBy: position)]
            while isSpace(nextChar) {
                position += 1
                nextChar = text[text.index(text.startIndex, offsetBy: position)]
            }
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
        }

        position += 1
        return getToken(currentChar)
        
    }

    private func getToken(_ currentChar: Character) -> Token{ // функция для получения токена в виде TokenType и его символа (только арифметические операции)
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
        let components = getFixedString(expression).split(whereSeparator: { $0 == " " })
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
        var updatedExpression = expression
        if expression.contains("[") && expression.contains("]"){
            updatedExpression = replaceArray(expression)
        }

        return addWhitespaces(updatedExpression)
    }
    
    private func replaceSigns(_ expression: String, _ sign: String) -> String{
        var updatedExpression = ""
        if !expression.contains(sign) {
            return expression
        } else if expression.contains("++"){
            let str = expression.split(separator: "+")
            updatedExpression += "\(str[0]) = \(str[0]) + 1"
        } else if expression.contains("--"){
            let str = expression.split(separator: "-")
            updatedExpression += "\(str[0]) = \(str[0]) - 1"
        } else {   
            guard let firstSign = sign.first else {
                fatalError("Invalid sign")
            }
            var str = expression.split(separator: firstSign)
            str[1].removeFirst()

            updatedExpression += "\(str[0]) = \(str[0]) \(firstSign) \(str[1])"

            if str.count > 2 {
                for i in 2..<str.count {
                    updatedExpression += " \(firstSign) \(str[i])"
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

    public func replaceArray(_ expression: String) -> String{

        var updatedExpression = ""
        var index = 0
        while index < expression.count{
            let char = expression[expression.index(expression.startIndex, offsetBy: index)]
            if char == "["{
                var count = 1
                var newIndex = index + 1
                while count != 0{
                    if expression[expression.index(expression.startIndex, offsetBy: newIndex)] == "["{
                        count += 1
                    } else if expression[expression.index(expression.startIndex, offsetBy: newIndex)] == "]"{
                        count -= 1
                    }
                    newIndex += 1
                }
                let str = expression[expression.index(expression.startIndex, offsetBy: index + 1)..<expression.index(expression.startIndex, offsetBy: newIndex - 1)]
                let normalizedString = normalizeString(String(str))
                let computedValue = Calculate(normalizedString).compare()
                updatedExpression += "[\(computedValue)]"
                index = newIndex - 1
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
    private var solvedExpression: String

    init() {
        self.solvedExpression = ""
        self.expression = ""
        self.type = .int
    }

    public func getSolvedExpression() -> String {
        return solvedExpression
    }

    public func setExpressionAndType(_ expression: String, _ type: VariableType) {
        self.expression = expression
        self.type = type
        updateSolvedExpression()
    }

    private func updateSolvedExpression(){
        let calculate = Calculate("") 

        var updatedExpression = expression
        if type == .String || (expression.contains("“") && expression.contains("”")) { 
            updatedExpression = updatedExpression.replacingOccurrences(of: "” ", with: "”").replacingOccurrences(of: " “", with: "“")
            calculate.setText(text: updatedExpression)
            let calculatedValue = calculate.compareString()
            if expression.contains("“") && expression.contains("”") {
                self.solvedExpression = "“" +  calculatedValue + "”"
            } else {
                self.solvedExpression = calculatedValue
            }

        } else if expression.contains("“") || expression.contains("”") || expression.contains("[") || expression.contains("]"){
            fatalError("Invalid type")
        } else{
            updatedExpression = updatedExpression.replacingOccurrences(of: "true", with: "1").replacingOccurrences(of: "false", with: "0")
            calculate.setText(text: updatedExpression)
            
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

class ArrayBuilder{
    private var expression: String
    private var type: VariableType
    private var solvedExpression: String
    private var result: String
    private var count: Int 
    private var children: [String]
    private var expressionSolver: ExpressionSolver = .init()

    init(_ expression: String, _ type: VariableType) {
        self.expression = expression
        self.type = type
        self.solvedExpression = ""
        self.result = "["
        self.count = 0
        self.children = []

        handleExpression()
    }

    public func getArrayElement(_ index: Int) -> String {
        if index >= children.count {
            fatalError("Invalid index")
        }
        return children[index]
    }
    public func getArray() -> String{
        // верни массив children в виде строки. То есть создай строку и в цикле добавь в нее все элементы массива children и верни эту строку
        var result = "["
        for i in 0..<children.count{
            result += children[i]
            if i != children.count - 1{
                result += ", "
            }
        }
        result += "]"
        return result
        

        
    }
    public func getArrayType() -> VariableType {
        return self.type
    }

    public func getArrayCount() -> Int {
        return self.count
    }

    public func getArrayChildren() -> [String] {
        return self.children
    }
    public func setArrayChildren(_ children: [String]) {
        self.children = children
    }

    public func setArrayValue(_ index: Int, _ value: String) {
        if index >= children.count || index < 0{
            fatalError("Invalid index")
        }
        children[index] = value
        
    }

    private func handleExpression(){
        let components = getArrayComponents(expression)

        self.count = components.count
        self.children = components.children
        self.type = components.type

        if count == 0 && children.count == 0 {
            result += "]"
            return
        } else if count == 0 || children.count == 0{
            fatalError("Invalid array")
        }
        for child in children {
            expressionSolver.setExpressionAndType(child, components.type)

            let solvedExpression = expressionSolver.getSolvedExpression()
            let valueType = getTypeByStringValue(solvedExpression)

            if valueType != components.type {
                fatalError("Invalid type of element in array")
            }
            result += solvedExpression + ", "
        }
        if components.count > 0{
            result.removeLast()
            result.removeLast()
        }
        result += "]"
    }


    private func getArrayComponents(_ expression: String) ->(type: VariableType, count: Int, children: [String]){
        return (getArrayType(expression), getArrayCount(expression), getArrayChildren(expression))
    }

    private func getArrayChildren(_ expression: String) -> [String]{
        // let components = expression.split(separator: "[")[1].split(separator: "]")[0].split(separator: ",")
        // получи компоненты массива через , и убери пробелы
        let components = expression.split(separator: "[")[1].split(separator: "]")[0].split(separator: ",").map({String($0.trimmingCharacters(in: .whitespaces))})
        var result = [String]()
        for component in components{
            result.append(String(component))
        }

        return result
    }

    private func getArrayCount(_ expression: String) -> Int{
        let component = expression.split(separator: "(")[1].split(separator: ")")
        let count = String(component[0])
        if let intValue = Int(count), intValue >= 0{
            return intValue
        } else {
            fatalError("Invalid array count")
        }
    }

    private func getArrayType(_ expression: String) -> VariableType{
        let component = expression.split(separator: ">")[0].split(separator: "<")
        let type = String(component[0])
        switch type {
        case "String":
            return .String
        case "int":
            return .int
        case "double":
            return .double
        case "bool":
            return .bool
        default:
            fatalError("Invalid type")
        }
    }
    
    private func getTypeByStringValue(_ expression: String) -> VariableType{
        if Int(expression) != nil {
            return .int
        } else if Double(expression) != nil {
            return .double
        } else if expression == "true" || expression == "false" {
            return .bool
        } else if expression.contains("“") && expression.contains("”") {
            return .String
        } else if expression.contains("[") && expression.contains("]") {
            return .array
        } else {
            return .another
        }
    }
}

class Interpreter {
    private var treeAST: Node
    internal var mapOfVariableStack = [[String: String]]()
    internal var mapOfArrayStack = [[String: ArrayBuilder]]()
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
        mapOfArrayStack.removeAll()

        let _ = traverseTree(treeAST)
    }
    
    func getPrintResult() -> String {
        return printResult
    }
    
    func traverseTree(_ node: Node) -> String{ 
        switch node.type{
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
        case .breakBlock:
            processBreakNode(node)
        case .continueBlock:
            processContinueNode(node)
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
            while mapOfArrayStack.count > 1 {
                mapOfArrayStack.removeLast()
            }
        } 
        print(mapOfVariableStack, "mapOfVariableStack")
        print(mapOfArrayStack, "mapOfArrayStack")
        for dictionary in mapOfArrayStack{
            for (key, value) in dictionary{
                print(key, value.getArray())
                
            }
        }
    }

    private func processPrintNode(_ node: Node){
        let components = getPrintValues(node.value)

        for component in components{

            if component.contains("“") && component.contains("”"){
                let leftQuoteCount = component.filter({$0 == "“"}).count
                let rightQuoteCount = component.filter({$0 == "”"}).count
                if leftQuoteCount != rightQuoteCount{
                    fatalError("Invalid syntax")
                }
                if leftQuoteCount == 1 && rightQuoteCount == 1{
                    printResult += "\(component)"
                } else {
                    let normalizedString = calculateArithmetic(component, .String)
                    printResult += "\(normalizedString) "
                }
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

        while index < expression.count {
            let char = expression[expression.index(expression.startIndex, offsetBy: index)]
            if char == "“" {
                while index < expression.count || char != "," {
                    let char = expression[expression.index(expression.startIndex, offsetBy: index)]
                    if char == "”" {
                        currentString += "\(char)"
                        index += 1
                        break
                    } else {
                        currentString += "\(char)"
                        index += 1
                    }
                }

            } else if char == ","{
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

    private func processBreakNode(_ node: Node){
    }

    private func processContinueNode(_ node: Node){
    }


    private func processAssignNode(_ node: Node) {
        let varName = assignmentVariableInstance.replaceArray(node.children[0].value)
        guard isVariable(varName) else { // проверяем, что мы пытается присвоить значение НЕ числу
            fatalError("Check your variable name")
        }
        var variableType: VariableType // здесь мы получаем тип переменной, которой присваиваем значение
        if let variableFromStack = getValueFromStack(varName), variableFromStack != "" {
            variableType = getTypeByStringValue(variableFromStack)
        } else {
            switch node.children[0].type {
            case .variable(let type):
                if type == .another{
                    fatalError("Variable is not declared")
                }
                variableType = type
            default:
                fatalError("Invalid syntax")
            }
        }
        if (variableType == .another){
            let assignValue = calculateArithmetic(node.children[1].value, variableType)
            assignValueToStack([varName: assignValue])   
            
        } else if (varName.contains("[") && varName.contains("]")) || variableType != .array{
            let assignValue = calculateArithmetic(node.children[1].value, variableType)
            guard isSameType(variableName: varName, value: assignValue) else {
                fatalError("Invalid type")
            }
            let lastDictionary = [varName: assignValue]
            assignValueToStack(lastDictionary)

        } else {
            let arrayBuilder = ArrayBuilder(node.children[1].value, variableType)
            updateMapArrayOfStack([varName: arrayBuilder])
        }

    }

    private func isVariable(_ expression: String) -> Bool{
        let regularValue = #"^[a-zA-Z]+[\w_]*(\[\s*(([a-zA-Z]+[\w_]*(\[\s*(([a-zA-Z]+[\w_]*)|([1-9]\d*)|([0]))\s*\])?)|([1-9]\d*)|([0]))\s*\])?$"#
        let arithmeticRegex = try! NSRegularExpression(pattern: regularValue, options: [])
        let isCondition = arithmeticRegex.firstMatch(in: expression, options: [], range: NSRange(location: 0, length: expression.utf16.count)) != nil

        return isCondition 
    }

    private func isSameType(variableName: String, value: String) -> Bool{ 
        guard let variableValue = getValueFromStack(variableName), variableValue != "" else {
            return true
        }
        let type = getTypeByStringValue(variableValue)

        if type == .int {
            return Int(value) != nil
        } else if type == .double {
            return Double(value) != nil
        } else if type == .bool {
            return value == "true" || value == "false"
        } else if type == .String {
            return value.contains("“") && value.contains("”")
        } else if type == .array {
            return value.contains("[") && value.contains("]") 
        } else {
            return false
        }
    }

    private func getTypeByStringValue(_ value: String) -> VariableType{
        if Int(value) != nil {
            return .int
        } else if Double(value) != nil {
            return .double
        } else if value == "true" || value == "false" {
            return .bool
        } else if value.contains("“") && value.contains("”") {
            return .String
        } else if value.contains("[") && value.contains("]") {
            return .array
        } else {
            return .another
        }
    }
    
    private func getValueFromStack(_ name: String) -> String? {
        for dictionary in mapOfVariableStack.reversed(){
            if let value = dictionary[name]{
                return value
            }
        }
        if name.contains("[") && name.contains("]"){
            let arrayName = String(name.split(separator: "[")[0])
            let arrayIndex = name.split(separator: "[")[1].split(separator: "]")[0]

            for array in mapOfArrayStack.reversed() {
                if let arrayBuilder = array[arrayName] {
                    let index = Int(arrayIndex) ?? -1
                    if index >= arrayBuilder.getArrayCount() || index < 0 {
                        fatalError("Invalid index")
                    }
                    return arrayBuilder.getArrayElement(index)
                }
            }
        }
        

        return ""
    }
    private func assignValueToStack(_ dictionary: [String: String]){
        for (key, value) in dictionary {
            var isAssigned = false
            if key.contains("[") && key.contains("]"){
                let arrayName = String(key.split(separator: "[")[0])
                let arrayIndex = key.split(separator: "[")[1].split(separator: "]")[0]

                for (index, array) in mapOfArrayStack.enumerated().reversed() {
                    if let arrayBuilder = array[arrayName] {
                        
                        let updatedValueIndex = Int(arrayIndex) ?? -1
                        if updatedValueIndex >= arrayBuilder.getArrayCount() || updatedValueIndex < 0 {
                            fatalError("Invalid index")
                        }
                        arrayBuilder.setArrayValue(updatedValueIndex, value)
                        mapOfArrayStack[index][arrayName] = arrayBuilder
                        break
                    }
                }
            } else {
                for dictionary in mapOfVariableStack.reversed(){
                    if dictionary[key] != nil {
                        mapOfVariableStack[mapOfVariableStack.count - 1][key] = value
                        isAssigned = true
                        break
                    }
                }
            }
            if !isAssigned{
                mapOfVariableStack[mapOfVariableStack.count - 1][key] = value
            }
        }
    }
    private func setValueFromStack(_ dictionary: [String: String]) {
        // print(dictionary, "dictionary in setValueFromStack")
        // print(mapOfVariableStack, "mapOfVariableStack in setValueFromStack")
        // print(mapOfArrayStack, "mapOfArrayStack in setValueFromStack")
        for (key, value) in dictionary {
            if key.contains("[") && key.contains("]"){
                let arrayName = String(key.split(separator: "[")[0])
                let arrayIndex = key.split(separator: "[")[1].split(separator: "]")[0]

                for (index, array) in mapOfArrayStack.enumerated().reversed() {
                    if let arrayBuilder = array[arrayName] {
                        
                        let updatedValueIndex = Int(arrayIndex) ?? -1
                        if updatedValueIndex >= arrayBuilder.getArrayCount() || updatedValueIndex < 0 {
                            fatalError("Invalid index")
                        }
                        arrayBuilder.setArrayValue(updatedValueIndex, value)
                        mapOfArrayStack[index][arrayName] = arrayBuilder
                        break
                    }
                }
            } else {
                for dictionary in mapOfVariableStack.reversed(){
                    if dictionary[key] != nil {
                        mapOfVariableStack[mapOfVariableStack.count - 1][key] = value
                        break
                    }
                }
            }
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
    
    private func handleIfBlockNode(_ node: Node){
        mapOfVariableStack.append([:])
        for child in node.children{

            if child.type == .ifBlock {
                child.setCountWasHere(0)
                mapOfVariableStack.append([:])
            }

            let _ = traverseTree(child)

            if child.type == .ifBlock {
                if let lastDictionary = mapOfVariableStack.last {
                    setValueFromStack(lastDictionary)
                    mapOfVariableStack.removeLast()
                }
            }
            if let lastDictionary = mapOfVariableStack.last {
                setValueFromStack(lastDictionary)
            }
        } 
        if let lastDictionary = mapOfVariableStack.last {
            setValueFromStack(lastDictionary)
            mapOfVariableStack.removeLast()
            
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
            setValueFromStack(lastDictionary)
            mapOfVariableStack.removeLast()
            
        }
    }

    private func processForLoopNode(_ node: Node) {

        guard let components = getForLoopComponents(node.value) else {
            fatalError("Invalid syntax")
        }
        mapOfVariableStack.append([:])


        if components[0] != "" {
            let variableComponents = getForLoopInitializationComponents(components[0])
            guard variableComponents.name != "", variableComponents.value != ""  else {
                fatalError("Invalid syntax")
            }
            guard isVariable(variableComponents.name) else{
                fatalError("Check your variable name")
            }
            var isThereVariable = false

            if let valueFromStack = getValueFromStack(variableComponents.name), valueFromStack != "" {
                isThereVariable = true
            }
            if isThereVariable && variableComponents.wasInitialized == 1 {
                fatalError("Variable already exists")

            } else if !isThereVariable && variableComponents.wasInitialized == 0{
                fatalError("Variable not found")
            }

            let normalizedVariableValue = assignmentVariableInstance.normalize(variableComponents.value)
            mapOfVariableStack[mapOfVariableStack.count - 1][variableComponents.name] = normalizedVariableValue


        } else if let variable = getConditionVariable(components[1]){
            let valueFromStack = getValueFromStack(variable)

            if valueFromStack != "" {
                mapOfVariableStack[mapOfVariableStack.count - 1][variable] = valueFromStack
            } 
            if mapOfVariableStack[mapOfVariableStack.count - 1][variable] == nil {
                fatalError("Variable or array variable not found")
            }
        }

        
        while calculateArithmetic(components[1], .bool) == "true" { 
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
            if let lastDictionary = mapOfVariableStack.last {
                setValueFromStack([variable.name: assignValue])
            }
        }

        if let lastDictionary = mapOfVariableStack.last {
            setValueFromStack(lastDictionary)
            mapOfVariableStack.removeLast()
        }
    }


    private func updateMapArrayOfStack(_ lastDictionary: [String: ArrayBuilder]) {
        if mapOfArrayStack.isEmpty {
            mapOfArrayStack.append(lastDictionary)
        } else {
            var variableFound = false

            for (key, value) in lastDictionary {
                for index in (0..<mapOfArrayStack.count).reversed() {

                    let dictionary = mapOfArrayStack[index]

                    if dictionary[key] != nil {
                        mapOfArrayStack[index][key] = value
                        variableFound = true
                        break

                    } else if index == 0 {
                        mapOfArrayStack.append([key: value])
                        variableFound = true
                        break
                    }
                }
                if variableFound {
                    break
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
        guard variable.count >= 3 + wasInitialized, variable[1 + wasInitialized] == "=" else {
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
            guard let firstSign = sign.first else {
                return expression
            }

            var str = expression.split(separator: firstSign)
            str[1].removeFirst()
            updatedExpression += "\(str[0]) = \(str[0]) \(firstSign) \(str[1])"

            if str.count > 2 {
                for i in 2..<str.count{
                    updatedExpression += " \(firstSign) \(str[i])"
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

        for dictionary in mapOfArrayStack {
            for (key, value) in dictionary {
                let children = value.getArrayChildren()
                for index in 0..<children.count {
                    lastDictionary["\(key)[\(index)]"] = children[index]
                }
            }
        }
        for dictionary in mapOfArrayStack {
            for (key, value) in dictionary {
                
                lastDictionary[key] = value.getArray()
            }
        }
        assignmentVariableInstance.setMapOfVariable(lastDictionary)
        let mapElement = assignmentVariableInstance.normalize(expression)
        if mapElement.contains("[") && mapElement.contains("]"){
            return mapElement
        }
        let expressionSolver = ExpressionSolver()
        expressionSolver.setExpressionAndType(mapElement, type)
        return expressionSolver.getSolvedExpression()
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


// алгоритм пузырьковой сортировки через 3 переменые
// c = [5, 3,13, 10,8,134,32,123,19,203]
// for (int i = 0; i < 10; i += 1){
//     for (int j = 0; j < 10; j += 1){
//         if (c[i] >= c[j]){
//             int temp = c[i];
//             c[i] = c[j];
//             c[j] = temp;
//         }
//     }
// }
// print(c)



 
var array: [IBlock] = []

array.append(Variable(id: 0, type: .int, name: "b", value: "10", isDebug: false))

array.append(Variable(id: 2, type: .array, name: "c", value: "<int>(10)[5, -1132,13, 10,-20,0,32,32,32,203]", isDebug: false))
array.append(Loop(id: 3, type: .forLoop, value: "int i = 0; i < 10; i += 1", isDebug: false))
array.append(BlockDelimiter(type: .begin))
array.append(Loop(id: 3, type: .forLoop, value: "int j = i + 1; j < 10; j += 1", isDebug: false))
array.append(BlockDelimiter(type: .begin))
array.append(Condition(isDebug: false, id: 4, type: .ifBlock, value: "c[i] > c[j]"))
array.append(BlockDelimiter(type: .begin))
array.append(Variable(id: 5, type: .int, name: "temp", value: "c[i]", isDebug: false))
array.append(Variable(id: 6, type: .another, name: "c[i]", value: "c[j]", isDebug: false))
array.append(Variable(id: 7, type: .another, name: "c[j]", value: "temp", isDebug: false))

array.append(BlockDelimiter(type: .end))
array.append(BlockDelimiter(type: .end))
array.append(Output(id: 8, value: "c", isDebug: false))
array.append(BlockDelimiter(type: .end))
array.append(BlockDelimiter(type: .end))
array.append(Output(id: 8, value: "c", isDebug: false))


let tree = Tree()
tree.setBlocks(array)
tree.buildTree()

let interpreter = Interpreter()
interpreter.setTreeAST(tree.rootNode)
print(interpreter.getPrintResult())


//“ ”


