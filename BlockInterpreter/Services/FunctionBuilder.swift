import Foundation

class FunctionBuilder{
    private var functionName: String
    private var functionReturnType: VariableType
    private var parameters: [String: VariableType]
    private var children: [Node]
    private var nodeId: Int

    init(_ functionName: String, _ functionReturnType: VariableType, _ parameters: [String: VariableType], _ children: [Node], _ nodeId: Int){
        self.functionName = functionName
        self.functionReturnType = functionReturnType
        self.parameters = parameters
        self.children = children
        self.nodeId = nodeId
    }

    public func getFunctionName() -> String{
        return functionName
    }

    public func getFunctionReturnType() -> VariableType{
        return functionReturnType
    }

    public func getFunctionParameters() -> [String: VariableType]{
        return parameters
    }
    public func getParametersCount() -> Int{
        return parameters.count
    }
    public func getChidren() -> [Node]{
        return children
    }
}