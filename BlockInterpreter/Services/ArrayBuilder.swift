import Foundation


class ArrayBuilder{
    private var expression: String
    private var type: VariableType
    private var solvedExpression: String
    private var result: String
    private var count: Int
    private var children: [String]
    private var expressionSolver: ExpressionSolver

    init(_ expression: String, _ type: VariableType) {
        self.expression = expression
        self.type = type
        self.solvedExpression = ""
        self.result = "["
        self.count = 0
        self.children = []
        self.expressionSolver = .init(type)

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

            // if valueType != components.type {
                // fatalError("Invalid type of element in array")
            // }
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
        if let intValue = Int(count), intValue >= 0 {
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
            return .arrayInt
        } else {
            return .another
        }
    }
}