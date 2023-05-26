import Foundation

struct ConsoleOutput: Error{
    var errorOutputValue: String;
    var errorIdArray: [Int]
}

enum ErrorType: Error {
    case nilTokenError
    case isNotDeclaredVariableError
    case alreadyExistsVariableError
    case variableNotFoundError
    case integerOwerflowError
    case invalidSyntaxError
    case unsupportedArrayError
    case invalidTokenTypeError
    case invalidIndexError
    case invalidValueError
    case invalidArrayError
    case invalidTypeError
    case invalidAppendValueError
    case invalidArrayValueError
    case invalidVariableNameError
    case invalidNodeError



    var description: String {
        switch self {
        case .invalidTokenTypeError:
            return "Token type errorType"
        case .nilTokenError:
            return "Nil token errorType"
        case .integerOwerflowError:
            return "Integer overflow errorType"
        case .invalidSyntaxError:
            return "Syntax errorType"
        case .unsupportedArrayError:
            return "Unsoported array errorType"
        case .invalidIndexError:
            return "Invalid index"
        case .invalidValueError:
            return "Invalid value"
        case .invalidArrayError:
            return "Invalid array"
        case .invalidTypeError:
            return "Invalid type"
        case .invalidAppendValueError:
            return "Invalid append value"
        case .invalidArrayValueError:
            return "Invalid array value"
        case .invalidVariableNameError:
            return "Invalid variable name"
        case .isNotDeclaredVariableError:
            return "Is not declared variable"
        case .alreadyExistsVariableError:
            return "Already exists variable"
        case .variableNotFoundError:
            return "Variable not found"
        case .invalidNodeError:
            return "Invalid node"
        }
    }
    var value: ErrorType {
        switch self {
        default:
            return self
        }
    }
}

protocol IBlock {

}

struct Flow: IBlock {
    let id: Int
    let type: FlowType
    let isDebug: Bool
}

struct Condition: IBlock {
    let id: Int
    let type: ConditionType
    let value: String
    let isDebug: Bool
}

struct Output: IBlock {
    let id: Int
    let value: String
    let isDebug: Bool
}

enum ArrayMethodType {
    case append
    case remove
    case pop
}

struct ArrayMethod: IBlock {
    let id: Int
    let type: ArrayMethodType
    let name: String
    let value: String
    let isDebug: Bool
}

struct Function: IBlock {
    let id: Int
    let name: String
    let type: VariableType
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
    let type: VariableType
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

    init(id: Int, type: VariableType, name: String, value: String, isDebug: Bool = false) {
        self.id = id
        self.type = type
        self.name = name
        self.value = value
        self.isDebug = isDebug
    }
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

enum FlowType {
    case begin
    case end
    case continueFlow
    case breakFlow
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
    case function(type: VariableType)
    case returnFunction(type: VariableType)
    case variable(type: VariableType)
    case arithmetic
    case print
    case root
    case breakBlock
    case continueBlock
    case cin
    case append
    case pop
    case remove
}


enum VariableType: String {
    case int
    case double
    case String
    case bool
    case another
    case arrayInt
    case arrayDouble
    case arrayString
    case arrayBool
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
            case let readBlock as Flow:
                if readBlock.type == FlowType.continueFlow {
                    if let continueNode = buildContinue(block) {
                        rootNode.addChild(continueNode)
                    }
                } else if readBlock.type == FlowType.breakFlow {
                    if let breakNode = buildBreak(block) {
                        rootNode.addChild(breakNode)
                    }
                }
                index += 1
            case let functionBlock as Function:
                if let functionNode = buildNode(getBlockAndMoveIndex(),
                        type: .function(type: functionBlock.type)) {
                    rootNode.addChild(functionNode)
                }

            case let methodBlock as ArrayMethod:
                let methodNode = buildMethodsOfList(method: methodBlock)
                rootNode.addChild(methodNode)
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

    private func buildMethodsOfList(method: ArrayMethod) -> Node {
        let node = Node(value: method.name + ";" + method.value,
                type: determineMethod(method: method),
                id: method.id, isDebug: method.isDebug)
        return node
    }

    private func determineMethod(method: ArrayMethod) -> AllTypes {
        switch method.type {
        case .append:
            return AllTypes.append
        case .remove:
            return AllTypes.remove
        case .pop:
            return AllTypes.pop
        }
    }

    private func buildBreak(_ block: IBlock) -> Node? {
        if let breakBlock = block as? Flow {
            if (breakBlock.type != FlowType.breakFlow) {
                return nil
            }
            let node = Node(value: "", type: AllTypes.breakBlock,
                    id: breakBlock.id, isDebug: breakBlock.isDebug)
            return node
        }
        return nil
    }

    private func buildContinue(_ block: IBlock) -> Node? {
        if let continueBlock = block as? Flow {
            if (continueBlock.type != FlowType.continueFlow) {
                return nil
            }
            let node = Node(value: "", type: AllTypes.continueBlock,
                    id: continueBlock.id, isDebug: continueBlock.isDebug)
            return node
        }
        return nil
    }

    private func getMatchingDelimiterIndex() -> Int? {
        var countBegin = 0
        for i in (index + 1)..<blocks.count {
            guard let block = blocks[i] as? Flow else {
                continue
            }
            countBegin += countForMatchingDelimiter(block)
            if countBegin == 0 {
                return i
            }
        }
        return nil
    }

    private func countForMatchingDelimiter(_ block: Flow) -> Int {
        if isEndDelimiter(block) {
            return -1
        } else if isBeginDelimiter(block) {
            return 1
        }
        return 0
    }

    private func isBeginDelimiter(_ block: Flow) -> Bool {
        block.type == FlowType.begin
    }

    private func isEndDelimiter(_ block: Flow) -> Bool {
        block.type == FlowType.end
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

    private func buildFirstNode(_ type: AllTypes, _ firstBlock: IBlock) -> Node? {
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
            if type == .function(type: function.type) {
                node = Node(value: function.name + ";" + function.value, type: .function(type: function.type),
                        id: function.id, isDebug: function.isDebug)
            } else {
                return nil
            }
        }
        return node
    }

    private func transferTypes(_ value: VariableType) -> AllTypes {
        switch value {
        case .int:
            return AllTypes.variable(type: .int)
        case .double:
            return AllTypes.variable(type: .double)
        case .String:
            return AllTypes.variable(type: .String)
        case .bool:
            return AllTypes.variable(type: .bool)
        case .another:
            return AllTypes.variable(type: .another)
        case .arrayInt:
            return AllTypes.variable(type: .arrayInt)
        case .arrayDouble:
            return AllTypes.variable(type: .arrayDouble)
        case .arrayString:
            return AllTypes.variable(type: .arrayString)
        case .arrayBool:
            return AllTypes.variable(type: .arrayBool)
        }
    }


    private func buildNode(_ block: [IBlock], type: AllTypes) -> Node? {
        guard let firstBlock = block.first else {
            return nil
        }

        let node = buildFirstNode(type, firstBlock)
        var index = 1

        while index < block.count {
            if let flowBlock = block[index] as? Flow {
                if flowBlock.type == FlowType.continueFlow {
                    let continueNode = buildContinue(flowBlock) ?? Node(value: "",
                            type: AllTypes.continueBlock, id: flowBlock.id,
                            isDebug: flowBlock.isDebug)
                    node?.addChild(continueNode)
                } else if flowBlock.type == FlowType.breakFlow {
                    let breakNode = buildBreak(flowBlock) ?? Node(value: "",
                            type: AllTypes.breakBlock, id: flowBlock.id,
                            isDebug: flowBlock.isDebug)
                    node?.addChild(breakNode)
                }
                index += 1
                continue
            } else if let variableBlock = block[index] as? Variable {
                let variableNode = buildVariableNode(variable: variableBlock)
                node?.addChild(variableNode)
            } else if let printBlock = block[index] as? Output {
                let printingNode = buildPrintingNode(printing: printBlock)
                node?.addChild(printingNode)
            } else if let method = block[index] as? ArrayMethod {
                let methodNode = buildMethodsOfList(method: method)
                node?.addChild(methodNode)
            } else if let readingDataBlock = block[index] as? ReadingData {
                let readingDataNode = Node(value: readingDataBlock.value,
                        type: .cin, id: readingDataBlock.id,
                        isDebug: readingDataBlock.isDebug)
                node?.addChild(readingDataNode)
            } else if let returnBlock = block[index] as? Returning {
                let returnNode = Node(value: returnBlock.value,
                        type: transferTypes(returnBlock.type), id: returnBlock.id,
                        isDebug: returnBlock.isDebug)
                node?.addChild(returnNode)
            } else if let nestedConditionBlock = block[index] as? Condition {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedConditionBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? Flow {
                        if blockEnd.type == FlowType.continueFlow ||
                                   blockEnd.type == FlowType.breakFlow {
                            nestedBlocks.append(block[additionIndex])
                        }

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
            } else if let nestedBlock = block[index] as? Flow {
                if nestedBlock.type == FlowType.breakFlow {
                    let breakNode = Node(value: "", type: .breakBlock,
                            id: nestedBlock.id, isDebug: nestedBlock.isDebug)
                    node?.addChild(breakNode)
                } else if nestedBlock.type == FlowType.continueFlow {
                    let continueNode = Node(value: "", type: .continueBlock,
                            id: nestedBlock.id, isDebug: nestedBlock.isDebug)
                    node?.addChild(continueNode)
                }
                index += 1
            } else if let nestedLoopBlock = block[index] as? Loop {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedLoopBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? Flow {
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
                    if let blockEnd = block[additionIndex] as? Flow {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildNode(nestedBlocks,
                        type: .function(type: nestedFunctionBlock.type)) {
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

    
    public func compare() throws -> Int {
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
            return result
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
        return result
    }



    private func term() throws -> Int {
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
                result %= try factor()
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


    private func factor()throws -> Int {
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
            return intValue
        case .minus:
            try moveToken(.minus)
            return try factor() * -1
        case .leftBrace:
            try moveToken(.leftBrace)
            let result = try compare()
            try moveToken(.rightBrace)
            return result

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
    private var nodeId: Int = 0
    private var consoleOutput: ConsoleOutput

    init(_ variableMap: [String: String], _ nodeId: Int = 0) {
        self.variableMap = variableMap
        self.nodeId = nodeId
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
    }
 
    public func setMapOfVariable(_ mapOfVariable: [String: String]) {
        self.variableMap.merge(mapOfVariable){(_, new) in new}
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
    }

 
    public func normalize(_ expression: String, _ nodeId: Int) throws -> String {
        self.nodeId = nodeId
        do{
            return try normalizeString(expression)
        } catch let errorType as ErrorType {
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput 
        }
    }

    private func normalizeString(_ expression: String)throws -> String {
        var result = "" 
        do {
            let components = try getFixedString(expression).split(whereSeparator: { $0 == " " })
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
        } catch let errorType as ErrorType{
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput 
        }

    }

    private func getFixedString(_ expression: String)throws -> String{

        let signsForReplacing = ["++","--","+=","-=","*=","/=","%="]
        for sign in signsForReplacing{
            if expression.contains(sign){
                do {
                    return try replaceSigns(expression, sign)
                } catch let errorType as ErrorType {
                    consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                    consoleOutput.errorIdArray.append(nodeId)
                    throw consoleOutput 
                }

            }
        }
        var updatedExpression = expression
        if expression.contains("[") && expression.contains("]"){
            updatedExpression = try replaceArray(expression)
        }

        return addWhitespaces(updatedExpression)
    }
    
    private func replaceSigns(_ expression: String, _ sign: String) throws -> String{
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
                throw ErrorType.invalidSyntaxError
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

    public func replaceArray(_ expression: String) throws -> String{

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
                do {
                    let normalizedString = try normalizeString(String(str))
                    let calculate = Calculate(normalizedString, nodeId)
                    let computedValue = try calculate.compare() 

                    updatedExpression += "[\(Int(computedValue))]"
                } catch let errorType as ErrorType {
                    consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                    consoleOutput.errorIdArray.append(nodeId)
                    throw consoleOutput
                }
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
    private var consoleOutput: ConsoleOutput
    private var nodeId: Int

    init() {
        self.solvedExpression = ""
        self.expression = ""
        self.type = .int
        self.nodeId = 0
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
    }

    public func getSolvedExpression() -> String {
        return solvedExpression
    }

    public func setExpressionAndType(_ expression: String, _ type: VariableType, _ nodeId: Int) throws{
        self.expression = expression
        self.type = type
        self.nodeId = nodeId
        self.consoleOutput =  ConsoleOutput(errorOutputValue: "", errorIdArray: [])
        do{
            try updateSolvedExpression()
        } catch let errorType as ErrorType {
            self.consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            self.consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput
        }
    }

    private func updateSolvedExpression() throws{
        let calculate = Calculate("", nodeId) 
        print(expression)
        var updatedExpression = expression

        if type == .String || (expression.contains("“") && expression.contains("”")) { 
            updatedExpression = updatedExpression.replacingOccurrences(of: "” ", with: "”").replacingOccurrences(of: " “", with: "“")
            calculate.setText(text: updatedExpression)
            let calculatedValue = try calculate.compareString()
            if expression.contains("“") && expression.contains("”") {
                self.solvedExpression = "“" +  calculatedValue + "”"
            } else {
                self.solvedExpression = calculatedValue
            }

        } else if expression.contains("“") || expression.contains("”"){
            throw ErrorType.invalidTokenTypeError
        } else{
            updatedExpression = updatedExpression.replacingOccurrences(of: "true", with: "1").replacingOccurrences(of: "false", with: "0")
            calculate.setText(text: updatedExpression)
            let calculatedValue = try calculate.compare()

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
    private var arrayType: VariableType
    private var childrenType: VariableType
    private var result: String
    private var count: Int 
    private var children: [String]
    private var expressionSolver: ExpressionSolver = .init()
    private var consoleOutput: ConsoleOutput
    private var nodeId: Int

    init(_ expression: String, _ arrayType: VariableType, _ nodeId: Int) throws {
        self.expression = expression
        self.arrayType = arrayType
        self.nodeId = nodeId

        self.consoleOutput =  ConsoleOutput(errorOutputValue: "", errorIdArray: [])
        self.childrenType = .int
        self.count = 0
        self.children = []

        self.result = ""
        do {
            try initializeValues()
        } catch let errorType as ErrorType {
            self.consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            self.consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput
        }
    }

    public func getArrayElement(_ index: Int) throws -> String {
        if index >= children.count {
            throw ErrorType.invalidIndexError
        }
        return children[index]
    }

    public func getArray() -> String{
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

    public func getChildrenType() -> VariableType {
        return self.arrayType
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

    public func setArrayValue(_ index: Int, _ value: String) throws {
        if index >= children.count || index < 0{
            throw ErrorType.invalidIndexError
        }
        if value == "" {
            throw ErrorType.invalidValueError
        }
        children[index] = value
    }

    public func append(_ value: String) throws{
        if value == "" {
            throw ErrorType.invalidValueError
        }
        if getTypeByStringValue(value) != self.childrenType{
            throw ErrorType.invalidTypeError
        }
        children.append(value)
        count += 1
    }

    public func insert(_ index: Int, _ value: String) throws {
        if index >= children.count || index < 0{
            throw ErrorType.invalidIndexError
        }
        if value == "" {
            throw ErrorType.invalidValueError
        }
        children.insert(value, at: index)
        count += 1
        self.result = updateArrayResultAfterMethods()
    }

    public func pop() throws {
        if children.count == 0 {
            throw ErrorType.invalidIndexError
        }
        children.removeLast()
        print(children)
        count -= 1
        self.result = updateArrayResultAfterMethods()
    }

    public func remove(_ index: Int) throws {
        if index >= children.count || index < 0{
            throw ErrorType.invalidIndexError
        }
        children.remove(at: index)
        count -= 1
        self.result = updateArrayResultAfterMethods()
    }

    private func initializeValues() throws{
        do{
            self.childrenType = try self.updateChildrenType()
            self.children = try self.updateArrayChildren()
            self.count = try self.updateArrayCount()
            self.result = try self.handleExpression()
        } catch let errorType as ErrorType {
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput
        }
        
    }

    private func handleExpression() throws -> String{
        if expression.first != "[" || expression.last != "]" || !isCorrectBrackets(expression){
            throw ErrorType.invalidArrayValueError
        } 

        if count == 0 && children.count == 0 {
            result += "]"
            return result
        }
        var result = "["
        for child in children {
            result += child + ", "
        }
        if count > 0{
            result.removeLast()
            result.removeLast()
        }
        result += "]"
        return result
    }

    private func isCorrectBrackets(_ expression: String) -> Bool{
        var count = 0
        for char in expression{
            if char == "["{
                count += 1
            } else if char == "]"{
                count -= 1
            }
        }
        return count == 0
    }
    private func updateArrayResultAfterMethods() -> String{
        var str = "["
        for child in children {
            str += child + ", "
        }
        if count > 0{
            str.removeLast()
            str.removeLast()
        }
        str += "]"
        return str
    }
    private func updateArrayChildren() throws -> [String]{
        let components = expression.split(separator: "[")[0].split(separator: "]")[0].split(separator: ",").map({String($0.trimmingCharacters(in: .whitespaces))})
        var result = [String]()
        for component in components{
            if component.first == "[" {
                throw ErrorType.unsupportedArrayError
            }
            print(childrenType, component,"childrenType, component")
            try expressionSolver.setExpressionAndType(String(component), childrenType, nodeId)

            let solvedExpression = expressionSolver.getSolvedExpression()
            let valueType = getTypeByStringValue(solvedExpression)

            if valueType != childrenType {
                throw ErrorType.invalidTypeError
            }
            result.append(String(solvedExpression))
        }

        return result
    }

    private func updateArrayCount() throws -> Int{
        let components = expression.split(separator: "[")[0].split(separator: "]")[0].split(separator: ",")
        var count = 0
        for component in components{
            if component.trimmingCharacters(in: .whitespaces) != ""{
                count += 1
            } else {
                throw ErrorType.invalidArrayValueError
            }
        }
        return count
    }

    private func updateChildrenType()throws -> VariableType{
        switch arrayType {
        case .arrayString:
            return .String
        case .arrayInt:
            return .int
        case .arrayDouble:
            return .double
        case .arrayBool:
            return .bool
        default:
            throw ErrorType.invalidArrayValueError
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
        } else {
            return .another
        }
    }
}

class Interpreter {
    private var treeAST: Node
    internal var mapOfVariableStack = [[String: String]]()
    internal var mapOfArrayStack = [[String: ArrayBuilder]]()
    private var assignmentVariableInstance: StringNormalizer
    private var printResult = ""
    private var consoleOutput: ConsoleOutput

    init() {
        treeAST = Node(value: "", type: .root, id: 0)
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
        assignmentVariableInstance = .init([:])
    }
    
    func setTreeAST(_ treeAST: Node) throws{
        printResult = ""
        self.treeAST = treeAST
        self.mapOfVariableStack = [[String: String]]()
        self.assignmentVariableInstance = .init([:])

        mapOfVariableStack.removeAll()
        mapOfArrayStack.removeAll()
        do{
            let _ = try traverseTree(treeAST)
        } catch let errorType as ErrorType{
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(treeAST.id)
            throw consoleOutput
        }
        
    }
    
    func getPrintResult() -> String {
        return printResult
    }
    
    func traverseTree(_ node: Node)throws { 
        do{
        switch node.type{
        case .root:
            try processRootNode(node)
        case .assign:
            try processAssignNode(node)
        case .ifBlock:
            try processIfBlockNode(node)
        case .elifBlock:
            try processElifBlockNode(node)
        case .elseBlock:
            try processElseBlockNode(node)
        case .whileLoop:
            try processWhileLoopNode(node)
        case .forLoop:
            try processForLoopNode(node)
        case .print:
            try processPrintNode(node)
        case .append:
            try processAppendNode(node)
        case .pop:
            try processPopNode(node)
        case .remove:
            try processRemoveNode(node)   
        case .breakBlock:
            processBreakNode(node)
        case .continueBlock:
            processContinueNode(node)
        default:
            throw ErrorType.invalidNodeError
        }
        } catch let errorType as ErrorType {
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(node.id)
            throw consoleOutput
        }
    }

    private func processAppendNode(_ node: Node) throws{
        let components = node.value.split(separator: ";").map({String($0.trimmingCharacters(in: .whitespaces))})

        let arrayName = components[0]
        let appendValues = getValuesFromExpression(components[1])
        if appendValues.count > 1{
            throw ErrorType.invalidAppendValueError
        }

        for dictionary in mapOfArrayStack.reversed(){
            if let arrayBuilder = dictionary[arrayName]{
                try arrayBuilder.append(appendValues[0])
                updateMapArrayOfStack([arrayName: arrayBuilder])
                break
            }
        }

    }

    private func processPopNode(_ node: Node)throws{
        let components = node.value.split(separator: ";").map({String($0.trimmingCharacters(in: .whitespaces))})
        let arrayName = components[0]

        for dictionary in mapOfArrayStack.reversed(){
            if let arrayBuilder = dictionary[arrayName]{
                do{
                    try arrayBuilder.pop()
                } catch let errorType as ErrorType {
                    consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                    consoleOutput.errorIdArray.append(node.id)
                    throw consoleOutput
                }
                updateMapArrayOfStack([arrayName: arrayBuilder])
                break
            }
        }
    }

    private func processRemoveNode(_ node: Node) throws{
        let components = node.value.split(separator: ";").map({String($0.trimmingCharacters(in: .whitespaces))})
        let arrayName = components[0]
        let index = components[1]

        for dictionary in mapOfArrayStack.reversed(){
            if let arrayBuilder = dictionary[arrayName]{
                guard let removeIndex =  Int(index) else{
                    throw ErrorType.invalidIndexError
                }
                try arrayBuilder.remove(Int(removeIndex))
                updateMapArrayOfStack([arrayName: arrayBuilder])
                break
            }
        }
    }

    private func processRootNode(_ node: Node)throws{
        mapOfVariableStack.append([:])

        for child in node.children{
            do{
                let _ = try traverseTree(child)
            } catch let errorType as ErrorType {
                consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                consoleOutput.errorIdArray.append(node.id)
                throw consoleOutput
            }

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
        // print(consoleOutput.errorOutputValue, "errorOutputValue")
        // print(consoleOutput.errorIdArray, "errorIdArray")
    }

    private func processPrintNode(_ node: Node) throws{
        let components = getValuesFromExpression(node.value)

        for component in components{
            if component.contains("“") && component.contains("”"){
                let leftQuoteCount = component.filter({$0 == "“"}).count
                let rightQuoteCount = component.filter({$0 == "”"}).count
                print(leftQuoteCount, rightQuoteCount)
                if leftQuoteCount != rightQuoteCount{
                    throw ErrorType.invalidSyntaxError
                }
                if leftQuoteCount == 1 && rightQuoteCount == 1{
                    printResult += "\(component)"
                } else {
                    let normalizedString = try calculateArithmetic(component, .String, node.id)
                    printResult += "\(normalizedString) "
                }
            } else if component.contains("“") || component.contains("”"){
                throw ErrorType.invalidSyntaxError
            } else {
                do{
                    let calculatedValue = try calculateArithmetic(component, .String, node.id)
                    printResult += "\(calculatedValue) "
                } catch let errorType as ErrorType {
                    consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                    consoleOutput.errorIdArray.append(node.id)
                    throw consoleOutput
                }
            }
        }

    }

    private func getValuesFromExpression(_ expression: String) -> [String]{
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

    private func processAssignNode(_ node: Node) throws{
        // print(node.children[0].value, "node.children[0].value")
        let varName = try assignmentVariableInstance.replaceArray(node.children[0].value)

        guard isVariable(varName) else { // проверяем, что мы пытается присвоить значение НЕ числу
            throw ErrorType.invalidVariableNameError
        }
        var variableType: VariableType // здесь мы получаем тип переменной, которой присваиваем значение
        if let variableFromStack = try getValueFromStack(varName), variableFromStack != "" {
            variableType = getTypeByStringValue(variableFromStack)
        } else {
            switch node.children[0].type {
            case .variable(let type):
                if type == .another{
                     throw ErrorType.variableNotFoundError
                }
                variableType = type
            default:
                throw ErrorType.invalidSyntaxError
            }
        }
        let arrayTypes = [VariableType.arrayInt, VariableType.arrayString, VariableType.arrayDouble]
        if (variableType == .another && !node.children[1].value.contains("[") && !node.children[1].value.contains("]")) {
            let assignValue = try calculateArithmetic(node.children[1].value, variableType, node.id)
            print(assignValue, "assignValue")
            try assignValueToStack([varName: assignValue])   
            
        } else if (varName.contains("[") && varName.contains("]")) || !arrayTypes.contains(variableType){
            let assignValue = try calculateArithmetic(node.children[1].value, variableType, node.id)
            guard isSameType(variableName: varName, value: assignValue) else {
                throw ErrorType.invalidTypeError
            }
            try assignValueToStack([varName: assignValue])

        } else {
            let arrayBuilder = try ArrayBuilder(node.children[1].value, variableType, node.id)
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
        var variableValue = ""
        do{
            variableValue = try getValueFromStack(variableName) ?? ""
            if variableValue == ""{
                return true
            }
        } catch {
            return false
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
        } else if type == .arrayInt {
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
            return .arrayInt
        } else {
            return .another
        }
    }
    
    private func getValueFromStack(_ name: String)throws -> String? {
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
                        throw ErrorType.invalidIndexError
                    }
                    return try arrayBuilder.getArrayElement(index)
                }
            }
        }
        

        return ""
    }

    private func assignValueToStack(_ dictionary: [String: String])throws{
        for (key, value) in dictionary {
            var isAssigned = false
            if key.contains("[") && key.contains("]"){
                let arrayName = String(key.split(separator: "[")[0])
                let arrayIndex = key.split(separator: "[")[1].split(separator: "]")[0]

                for (index, array) in mapOfArrayStack.enumerated().reversed() {
                    if let arrayBuilder = array[arrayName] {
                        
                        let updatedValueIndex = Int(arrayIndex) ?? -1
                        if updatedValueIndex >= arrayBuilder.getArrayCount() || updatedValueIndex < 0 {
                            throw ErrorType.invalidIndexError
                        }
                        try arrayBuilder.setArrayValue(updatedValueIndex, value)
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

    private func setValueFromStack(_ dictionary: [String: String]) throws{
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
                            throw ErrorType.invalidIndexError
                        }
                        try arrayBuilder.setArrayValue(updatedValueIndex, value)
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

    private func processIfBlockNode(_ node: Node) throws{ 
        do{
            let calculatedValue = try calculateArithmetic(node.value, .bool, node.id)
            if (calculatedValue == "true" && node.getCountWasHere() == 0){
                try handleIfBlockNode(node) 
                node.setCountWasHere(2)
            } else{
                node.setCountWasHere(1)
            }
        } catch let errorType as ErrorType{
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(node.id)
            throw consoleOutput
        } catch{
            consoleOutput.errorOutputValue += String(describing: error) + "\n"
            consoleOutput.errorIdArray.append(node.id)
            throw consoleOutput
        }
        

    }

    private func processElifBlockNode(_ node: Node) throws{
        do{
            let calculatedValue = try calculateArithmetic(node.value, .bool, node.id)
            if (calculatedValue == "true" && node.getCountWasHere() == 0){
                try handleIfBlockNode(node) 
                node.setCountWasHere(2)
            } else{
                node.setCountWasHere(1)
            }
        } catch let errorType as ErrorType{
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(node.id)
            throw consoleOutput
        }
        
        

    }

    private func processElseBlockNode(_ node: Node)throws{
        if (node.getCountWasHere() == 1){
            do{
                try handleIfBlockNode(node) 
            } catch let errorType as ErrorType {
                consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                consoleOutput.errorIdArray.append(node.id)
                throw consoleOutput
            }
            
        } 
    }
    
    private func handleIfBlockNode(_ node: Node) throws {
        do{
            mapOfVariableStack.append([:])
        for child in node.children{

            if child.type == .ifBlock {
                child.setCountWasHere(0)
                mapOfVariableStack.append([:])
            }
            
            let _ = try traverseTree(child)

            if child.type == .ifBlock {
                if let lastDictionary = mapOfVariableStack.last {
                    do {
                        try setValueFromStack(lastDictionary)
                    } catch let errorType as ErrorType {
                        consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                        consoleOutput.errorIdArray.append(node.id)
                        throw consoleOutput
                    }
                    mapOfVariableStack.removeLast()
                }
            }
            if let lastDictionary = mapOfVariableStack.last {
                do {
                    try setValueFromStack(lastDictionary)
                } catch let errorType as ErrorType {
                    consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                    consoleOutput.errorIdArray.append(node.id)
                    throw consoleOutput
                }
            }
        } 
        if let lastDictionary = mapOfVariableStack.last {
            do {
                try setValueFromStack(lastDictionary)
            } catch let errorType as ErrorType {
                consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                consoleOutput.errorIdArray.append(node.id)
                throw consoleOutput
            }
            mapOfVariableStack.removeLast()
            
        }

        } catch let errorType as ErrorType {
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(node.id)
            throw consoleOutput
        }
        
    }

    private func processWhileLoopNode(_ node: Node) throws {
        let condition = node.value
        if condition == "" {
            throw ErrorType.invalidSyntaxError
        }
        mapOfVariableStack.append([:])
        while try calculateArithmetic(node.value, .bool, node.id) == "true" { 

            for child in node.children {
                if child.type == .ifBlock {
                    child.setCountWasHere(0)
                }
                let _ = try! traverseTree(child)
            }
        }
        if let lastDictionary = mapOfVariableStack.last {
            try setValueFromStack(lastDictionary)
            mapOfVariableStack.removeLast()
        }
    }

    private func processForLoopNode(_ node: Node) throws{

        guard let components = try getForLoopComponents(node.value) else {
            throw ErrorType.invalidSyntaxError
        }
        mapOfVariableStack.append([:])


        if components[0] != "" {
            let variableComponents = try getForLoopInitializationComponents(components[0])
            guard variableComponents.name != "", variableComponents.value != ""  else {
                throw ErrorType.invalidSyntaxError
            }
            guard isVariable(variableComponents.name) else{
                throw ErrorType.invalidVariableNameError
            }
            var isThereVariable = false

            if let valueFromStack = try getValueFromStack(variableComponents.name), valueFromStack != "" {
                isThereVariable = true
            }
            if isThereVariable && variableComponents.wasInitialized == 1 {
                throw ErrorType.alreadyExistsVariableError

            } else if !isThereVariable && variableComponents.wasInitialized == 0{
                throw ErrorType.variableNotFoundError
            }

            do {
                let normalizedVariableValue = try assignmentVariableInstance.normalize(variableComponents.value, node.id)
                mapOfVariableStack[mapOfVariableStack.count - 1][variableComponents.name] = normalizedVariableValue
            } catch let errorType as ErrorType {
                consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                consoleOutput.errorIdArray.append(node.id)
                throw consoleOutput
            }

        } else if let variable = getConditionVariable(components[1]){
            let valueFromStack = try getValueFromStack(variable)

            if valueFromStack != "" {
                mapOfVariableStack[mapOfVariableStack.count - 1][variable] = valueFromStack
            } 
            if mapOfVariableStack[mapOfVariableStack.count - 1][variable] == nil {
                throw ErrorType.variableNotFoundError
            }
        }


        while try calculateArithmetic(components[1], .bool, node.id) == "true" { 
            for child in node.children {
                if child.type == .ifBlock {
                    child.setCountWasHere(0)
                }
                let _ = try traverseTree(child)
            }

            guard let variable = getStepComponents(components[2]) else{
                throw ErrorType.invalidSyntaxError
            }
            let assignValue = String(try calculateArithmetic(variable.value, .int, node.id))
            try setValueFromStack([variable.name: assignValue])
        }

        if let lastDictionary = mapOfVariableStack.last {
            try setValueFromStack(lastDictionary)
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

    private func getForLoopComponents(_ value: String)throws -> [String]? {
        let components = value.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 3 else {
            return nil
        }
        return components
    }
    private func getForLoopInitializationComponents(_ component: String) throws -> (name: String, value: String, wasInitialized: Int) {
        var wasInitialized = 0

        if component.contains("int") || component.contains("string") {
            wasInitialized = 1
        }
        let variable = component.split(whereSeparator: { $0 == " " }).map{ $0.trimmingCharacters(in: .whitespaces) }
        guard variable.count >= 3 + wasInitialized, variable[1 + wasInitialized] == "=" else {
            throw ErrorType.invalidSyntaxError
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

    private func calculateArithmetic(_ expression: String, _ type: VariableType, _ nodeId: Int)throws -> String {
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
        do{
            let mapElement = try assignmentVariableInstance.normalize(expression, nodeId)

            let expressionSolver = ExpressionSolver()
            try expressionSolver.setExpressionAndType(mapElement, type, nodeId)

            return expressionSolver.getSolvedExpression()
        } catch let errorType as ErrorType{
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput
        }
        
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

// array.append(Variable(id: 0, type: .String, name: "b", value: "“fdf” + “fdf”", isDebug: false))

array.append(Variable(id: 0, type: .arrayString, name: "c", value: "[“10 + 25”,“94”,“3”, “-1132 ”,“13 ”]", isDebug: false))
array.append(ArrayMethod(id: 1, type: .append, name: "c", value: "“10 + 25”", isDebug: false))
array.append(Output(id: 2, value: "c", isDebug: false))
array.append(ArrayMethod(id: 4, type: .pop, name: "c", value: "", isDebug: false))
array.append(Output(id: 5, value: "c", isDebug: false))
array.append(ArrayMethod(id: 6, type: .pop, name: "c", value: "", isDebug: false))
array.append(Output(id: 7, value: "c", isDebug: false))
array.append(ArrayMethod(id: 8, type: .pop, name: "c", value: "", isDebug: false))
array.append(Output(id: 9, value: "c", isDebug: false))
array.append(ArrayMethod(id: 10, type: .pop, name: "c", value: "", isDebug: false))
array.append(Output(id: 11, value: "c", isDebug: false))

array.append(Loop(id: 12, type: .forLoop, value: "int i = 0; i < 10; i += 1", isDebug: false))
array.append(Flow(id: 13, type: .begin, isDebug: false))
array.append(Loop(id: 14, type: .forLoop, value: "int j = i + 1; j < 10; j += 1", isDebug: false))
array.append(Flow(id: 15, type: .begin, isDebug: false))
array.append(Condition(id: 16, type: .ifBlock, value: "c[i] > c[j]", isDebug: false))
array.append(Flow(id: 17, type: .begin, isDebug: false))
array.append(Variable(id: 18, type: .int, name: "temp", value: "c[i]", isDebug: false))
array.append(Variable(id: 19, type: .another, name: "c[i]", value: "c[j]", isDebug: false))
array.append(Variable(id: 20, type: .another, name: "c[j]", value: "temp", isDebug: false))

array.append(Flow(id: 21, type: .end, isDebug: false))
array.append(Flow(id: 22, type: .end, isDebug: false))
array.append(Output(id: 23, value: "c", isDebug: false))
array.append(Flow(id: 24,type: .end, isDebug: false))
array.append(Flow(id: 25, type: .end, isDebug: false))
// array.append(Output(id: 26, value: "b", isDebug: false))
// array.append(Condition(id: 1, type: .ifBlock,
//         value: "((1 < 3) || ((12 > 10) && (1 > 0)))", isDebug: false))
// array.append(Flow(id: 2, type: .begin, isDebug: false))
// array.append(Output(id: 3, value: "“ssss ”", isDebug: false))
// array.append(Flow(id: 4, type: .end, isDebug: false))

let tree = Tree()
tree.setBlocks(array)
tree.buildTree()

let interpreter = Interpreter()
do {
    try interpreter.setTreeAST(tree.rootNode)
} catch let errorType as ErrorType {
    print(errorType)
}
print(interpreter.getPrintResult())


//“ ”


