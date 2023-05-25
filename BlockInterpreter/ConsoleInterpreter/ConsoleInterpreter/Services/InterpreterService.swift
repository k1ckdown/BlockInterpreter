
import Foundation

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
                // printResult += "\(component) "
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

        } else if (varName.contains("[") && varName.contains("]")) || variableType != .arrayInt{
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