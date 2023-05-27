import Foundation


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
            return .string
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
            return .string
        } else {
            return .void
        }
    }
}