
import Foundation

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
