
import Foundation

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
