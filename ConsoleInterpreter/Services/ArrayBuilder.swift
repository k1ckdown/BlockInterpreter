import Foundation


class ArrayBuilder{
    private var expression: String
    private var arrayType: VariableType
    private var childrenType: VariableType
    private var result: String
    private var count: Int 
    private var children: [String]
    private var expressionSolver: ExpressionSolver = .init()

    init(_ expression: String, _ arrayType: VariableType) {
        self.expression = expression
        self.arrayType = arrayType
        self.childrenType = .int
        self.count = 0
        self.children = []

        self.result = ""
        self.initializeValues()
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

    public func setArrayValue(_ index: Int, _ value: String) {
        if index >= children.count || index < 0{
            fatalError("Invalid index")
        }
        if value == "" {
            fatalError("Invalid value")
        }
        children[index] = value
        
    }
    private func initializeValues(){
        self.childrenType = self.updateChildrenType()
        print(self.childrenType, "childrenType")
        self.children = self.updateArrayChildren()
        print(self.children, "children")
        self.count = self.updateArrayCount()
        print(self.count, "count")
        self.result = self.handleExpression()
        print("result", self.result)
        
    }

    private func handleExpression() -> String{
        if expression.first != "[" || expression.last != "]" || !isCorrectBrackets(expression){
            fatalError("Invalid array")
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

    private func updateArrayChildren() -> [String]{
        let components = expression.split(separator: "[")[0].split(separator: "]")[0].split(separator: ",").map({String($0.trimmingCharacters(in: .whitespaces))})
        var result = [String]()
        for component in components{
            if component.first == "[" {
                fatalError("Invalid array, we can't use array in array:((")
            }
            print(childrenType, component,"childrenType, component")
            expressionSolver.setExpressionAndType(String(component), childrenType)

            let solvedExpression = expressionSolver.getSolvedExpression()
            let valueType = getTypeByStringValue(solvedExpression)

            if valueType != childrenType {
                fatalError("Invalid type of element in array")
            }
            result.append(String(solvedExpression))
        }

        return result
    }

    private func updateArrayCount() -> Int{
        let components = expression.split(separator: "[")[0].split(separator: "]")[0].split(separator: ",")
        var count = 0
        for component in components{
            if component.trimmingCharacters(in: .whitespaces) != ""{
                count += 1
            } else {
                fatalError("Invalid array, empty element")
            }
        }
        return count
    }

    private func updateChildrenType() -> VariableType{
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
        } else {
            return .another
        }
    }
}