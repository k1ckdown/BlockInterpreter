import Foundation
 
 
class AssignmentVariableInt {
    private(set) var mapOfVariablesInt: [String: String] = [:]
    private(set) var calculate: Calculate
 
    init(_ variableInt: [String: String]) {
        self.calculate = Calculate("")
        self.mapOfVariablesInt.merge(variableInt){(_, new) in new}
    }
 
    func setMapOfVariableInt(_ mapOfVariableInt: [String: String]) {
        self.mapOfVariablesInt.merge(mapOfVariableInt){(_, new) in new}
    }
 
    func assignInt(variable: Variable) -> (String, String) {
        variable.setValue(value: String(Calculate(normalize(variable.value)).compute()))
        return (variable.name, variable.value)
    }
 
    private func normalize(_ name: String) -> String {
        var result = ""
        let components = name.split(whereSeparator: { $0 == " " })
        for component in components {
            if let intValue = Int(component) {
                result += "\(intValue)"
            } else if let value = mapOfVariablesInt[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }
}
