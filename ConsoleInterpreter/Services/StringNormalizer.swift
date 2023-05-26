import Foundation


class StringNormalizer {
    private var variableMap: [String: String]
    private var nodeId: Int = 0
    private var consoleOutput: ConsoleOutput
 
    init(_ variableMap: [String: String], _ nodeId: Int = 0) {
        self.variableMap = variableMap
        self.nodeId = nodeId
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
    }
 
    public func setMapOfVariable(_ mapOfVariable: [String: String]) {
        self.variableMap.merge(mapOfVariable){(_, new) in new}
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
    }
 
 
    public func normalize(_ expression: String, _ nodeId: Int) throws -> String {
        self.nodeId = nodeId
        do{
            return try normalizeString(expression)
        } catch let errorType as ErrorType {
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput 
        }
    }
 
    private func normalizeString(_ expression: String)throws -> String {
        var result = "" 
        do {
            let components = try getFixedString(expression).split(whereSeparator: { $0 == " " })
            for component in components {
                if let intValue = Int(component) {
                    result += "\(intValue)"
                } else if let value = variableMap[String(component)] {
                    result += "\(value)"
                } else {
                    result += "\(component)"
                }
            }
            return result
        } catch let errorType as ErrorType{
            consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput 
        }
 
    }
 
    private func getFixedString(_ expression: String)throws -> String{
 
        let signsForReplacing = ["++","--","+=","-=","*=","/=","%="]
        for sign in signsForReplacing{
            if expression.contains(sign){
                do {
                    return try replaceSigns(expression, sign)
                } catch let errorType as ErrorType {
                    consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                    consoleOutput.errorIdArray.append(nodeId)
                    throw consoleOutput 
                }
 
            }
        }
        var updatedExpression = expression
        if expression.contains("[") && expression.contains("]"){
            updatedExpression = try replaceArray(expression)
        }
 
        return addWhitespaces(updatedExpression)
    }
 
    private func replaceSigns(_ expression: String, _ sign: String) throws -> String{
        var updatedExpression = ""
        if !expression.contains(sign) {
            return expression
        } else if expression.contains("++"){
            let str = expression.split(separator: "+")
            updatedExpression += "\(str[0]) = \(str[0]) + 1"
        } else if expression.contains("--"){
            let str = expression.split(separator: "-")
            updatedExpression += "\(str[0]) = \(str[0]) - 1"
        } else {   
            guard let firstSign = sign.first else {
                throw ErrorType.invalidSyntaxError
            }
            var str = expression.split(separator: firstSign)
            str[1].removeFirst()
 
            updatedExpression += "\(str[0]) = \(str[0]) \(firstSign) \(str[1])"
 
            if str.count > 2 {
                for i in 2..<str.count {
                    updatedExpression += " \(firstSign) \(str[i])"
                }
            }
 
 
        }
 
        return updatedExpression
    }
 
    private func addWhitespaces(_ expression: String ) -> String{
 
        let arithmeticSigns = ["+","*", "/", "%", "(", ")", "-", "=", "<", ">"]
        let doubleArithmeticSigns = ["==", "!=", "<=", ">=", "&&", "||"]
 
        var index = 0
        var updatedExpression = ""
 
        while index < expression.count{
            let char = expression[expression.index(expression.startIndex, offsetBy: index)]
            if index + 1 < expression.count - 1 && doubleArithmeticSigns.contains("\(char)\(expression[expression.index(expression.startIndex, offsetBy: index + 1)])"){
                updatedExpression += " \(char)\(expression[expression.index(expression.startIndex, offsetBy: index + 1)]) "
                index += 1
            } else if char == "-" , index + 1 < expression.count - 1, isNumber(expression[expression.index(expression.startIndex, offsetBy: index + 1)]) {
                updatedExpression += " \(char)"
            }else if arithmeticSigns.contains(String(char)){
                updatedExpression += " \(char) "
            } else {
                updatedExpression += "\(char)"
            }
            index += 1
        }
 
        return updatedExpression
    }
 
    public func replaceArray(_ expression: String) throws -> String{
 
        var updatedExpression = ""
        var index = 0
 
        while index < expression.count{
            let char = expression[expression.index(expression.startIndex, offsetBy: index)]
            if char == "["{
                var count = 1
                var newIndex = index + 1
                while count != 0{
                    if expression[expression.index(expression.startIndex, offsetBy: newIndex)] == "["{
                        count += 1
                    } else if expression[expression.index(expression.startIndex, offsetBy: newIndex)] == "]"{
                        count -= 1
                    }
                    newIndex += 1
                }
                let str = expression[expression.index(expression.startIndex, offsetBy: index + 1)..<expression.index(expression.startIndex, offsetBy: newIndex - 1)]
                do {
                    let normalizedString = try normalizeString(String(str))
                    let calculate = Calculate(normalizedString, nodeId)
                    let computedValue = try calculate.compare() 
 
                    updatedExpression += "[\(Int(computedValue))]"
                } catch let errorType as ErrorType {
                    consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
                    consoleOutput.errorIdArray.append(nodeId)
                    throw consoleOutput
                }
                index = newIndex - 1
            } else {
                updatedExpression += "\(char)"
            }
            index += 1
        }
        return updatedExpression
    }
 
    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
}

