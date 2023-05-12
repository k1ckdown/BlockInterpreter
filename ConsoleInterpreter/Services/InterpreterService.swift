
import Foundation

class Interpreter {
    private var treeAST: Node
    internal var mapOfVariableStack = [[String: String]]()
    private var assignmentVariableInstance = AssignmentVariable([:])
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
    
    func traverseTree(_ treeAST: Node) -> String { 
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
        case .loop:
            processLoopNode(treeAST)
        case .print:
            processPrintNode(treeAST)
        default:
            return "" // в этом случае нужно возвращать ID блока
        }
         
        return ""
    }
    private func processLoopNode(_ node: Node){
        // print("processLoopNode")
        // print(node.value)
    }

 
    private func processPrintNode(_ node: Node){
        let calculatedValue = calculateArithmetic(node.value)
        // print(calculatedValue)
        // print("processPrintNode")
        if let value = Int(calculatedValue) {
            printResult += "\(value)\n"
        } else {
            printResult += "\(node.value)\n"
        }
    }

    private func processIfBlockNode(_ node: Node){
        let calculatedValue = calculateArithmetic(node.value)

        guard let value = Int(calculatedValue) else {
            fatalError("Invalid syntax")
        }
        if value != 0{
            mapOfVariableStack.append([:])

            for child in node.children{
                let _ = traverseTree(child)

                if child.type == .ifBlock {
                    mapOfVariableStack.append([:])
                }

                if let lastDictionary = mapOfVariableStack.last {
                    mapOfVariableStack.removeLast()
            
                    for (key, value) in lastDictionary {
                        for (index, var dictionary) in mapOfVariableStack.enumerated().reversed() {
                            if dictionary[key] != nil {
                                dictionary[key] = value
                                mapOfVariableStack[index] = dictionary
                                break
                            }
                        }
                    }

                }
            }
        }
    }



    private func processRootNode(_ node: Node){
        mapOfVariableStack.append([:])
        for child in node.children{
            let _ = traverseTree(child)
        } 
        // print(mapOfVariableStack)
        // print(printResult)
    }

    private func processVariableNode(_ node: Node) -> String{
        return node.value
    }

    private func processAssignNode(_ node: Node){
    
        let varName = traverseTree(node.children[0])
        let assignValue = traverseTree(node.children[1])
        if var lastDictionary = mapOfVariableStack.last {
            lastDictionary[varName] = assignValue
            mapOfVariableStack[mapOfVariableStack.count - 1] = lastDictionary
        }
    }

    private func processArithmeticNode(_ node: Node) -> String {
        return calculateArithmetic(node.value)
    }

    private func calculateArithmetic(_ expression: String) -> String {
        var lastDictionary:[String: String] = [:]
        for dictionary in mapOfVariableStack {
            lastDictionary.merge(dictionary){(_, new) in new}
        }
        assignmentVariableInstance.setMapOfVariable(lastDictionary)

        let variableForInt = Variable(
            id: 1,
            type: VariableType.int,
            name: "temp",
            value: expression
            
        )
        let mapElement = assignmentVariableInstance.assign(variableForInt)
        if mapElement == "" {
            fatalError("Invalid syntax")
        } else if let intValue = Int(mapElement) {
            return "\(intValue)"
        } else {
            return mapElement
        }
    }
}
