import Foundation

class AssignmentVariable {
    private var variableIntMap: [String: String]

    init(_ variableIntMap: [String: String]) {
        self.variableIntMap = variableIntMap
    }
 
    public func setMapOfVariable(_ mapOfVariable: [String: String]) {
        self.variableIntMap.merge(mapOfVariable){(_, new) in new}
    }
 
    public func assign(_ variable: Variable) -> String {
        if variable.type == .int {
            return assignInt(variable.value)
        } else if variable.type == .string {
            return assignString(variable.value)
        } else {
            fatalError("Invalid variable type")
        }
    }

    private func assignInt(_ variable: String) -> String {

        let normalizedString = normalizeInt(variable)
        let computedString = String(Calculate(normalizedString).compare())
        return computedString
    }

    private func assignString(_ variable: String) -> String {
        let normalizedString = normalizeString(variable)
        return normalizedString
    }

    private func normalizeString(_ name: String) -> String {
        var result = "" 
        let components = name.split(whereSeparator: { $0 == " " })
        for component in components {
            if let value = variableIntMap[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }
    private func normalizeInt(_ name: String) -> String {
        var result = "" 
        let components = name.split(whereSeparator: { $0 == " " })
        for component in components {
            if let intValue = Int(component) {
                result += "\(intValue)"
            } else if let value = variableIntMap[String(component)] {
                result += "\(value)"
            } else {
                result += "\(component)"
            }
        }
        return result
    }
}


