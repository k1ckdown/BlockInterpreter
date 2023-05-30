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
 
    func getFunctionName() -> String{
        return functionName
    }
 
    func getFunctionReturnType() -> VariableType{
        return functionReturnType
    }
 
    func getFunctionParameters() -> [String: VariableType]{
        return parameters
    }
    
    func getParametersCount() -> Int{
        return parameters.count
    }
    
    func getChidren() -> [Node]{
        return children
    }
}
