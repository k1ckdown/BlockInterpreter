
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
        assignmentVariableInstance = .init([:])
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
//        print(mapOfVariableStack, "mapOfVariableStack")
    }

    private func processPrintNode(_ node: Node){
        let calculatedValue = calculateArithmetic(node.value)
        if let value = Int(calculatedValue) {
            printResult += "\(value) \n"
        } else {
            for dictionary in mapOfVariableStack.reversed(){
                if dictionary[node.value] != nil{
                    printResult += "\(dictionary[node.value]!) \n"
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

//        print("mapOfVariableStack = \(mapOfVariableStack)")
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

        guard variable.count >= 3 + isContain || variable[1 + isContain] != "=" else  {
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
//        print("components = \(components)")
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
                    type: VariableType.string,
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
