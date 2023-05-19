import Foundation


class StringNormalizer {
    private var variableMap: [String: String]

    init(_ variableMap: [String: String]) {
        self.variableMap = variableMap
    }
 
    public func setMapOfVariable(_ mapOfVariable: [String: String]) {
        self.variableMap.merge(mapOfVariable){(_, new) in new}
    }

 
    public func normalize(_ expression: String) -> String {
        return normalizeString(expression)
    }


    private func normalizeString(_ expression: String) -> String {
        var result = "" 
        let updatedExpression = getFixedString(expression)
        let components = updatedExpression.split(whereSeparator: { $0 == " " })
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
    }

    private func getFixedString(_ expression: String) -> String{

        let signsForReplacing = ["++","--","+=","-=","*=","/=","%="]
        for sign in signsForReplacing{
            if expression.contains(sign){
                return replaceSigns(expression, sign)
            }
        }

        return addWhitespaces(expression)
    }

    private func replaceSigns(_ expression: String, _ sign: String) -> String{
        var updatedExpression = ""
        if expression.contains("++"){
            let str = expression.split(separator: "+")
            updatedExpression += "\(str[0]) = \(str[0]) + 1"
        } else if expression.contains("--"){
            let str = expression.split(separator: "-")
            updatedExpression += "\(str[0]) = \(str[0]) - 1"
        } else {
            var str = expression.split(separator: sign.first!)
            str[1].removeFirst()
            updatedExpression += "\(str[0]) = \(str[0]) \(sign.first!) \(str[1])"
            if str.count > 2 {
                for i in 2..<str.count{
                    updatedExpression += " \(sign.first!) \(str[i])"
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

    private func isNumber(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
}

