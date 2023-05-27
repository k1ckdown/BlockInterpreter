import Foundation


class ExpressionSolver{
    private var expression: String
    private var type: VariableType
    private var solvedExpression: String
    private var consoleOutput: ConsoleOutput
    private var nodeId: Int

    init() {
        self.solvedExpression = ""
        self.expression = ""
        self.type = .int
        self.nodeId = 0
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
    }

    public func getSolvedExpression() -> String {
        return solvedExpression
    }

    public func setExpressionAndType(_ expression: String, _ type: VariableType, _ nodeId: Int) throws{
        self.expression = expression
        self.type = type
        self.nodeId = nodeId
        self.consoleOutput = ConsoleOutput(errorOutputValue: "", errorIdArray: [])
        do {
            try updateSolvedExpression()
        } catch let errorType as ErrorType {
            self.consoleOutput.errorOutputValue += String(describing: errorType) + "\n"
            self.consoleOutput.errorIdArray.append(nodeId)
            throw consoleOutput
        }
    }

    private func updateSolvedExpression() throws{
        let calculate = Calculate("", nodeId)
        var updatedExpression = expression
        // && first instead ||
        if type == .string && (expression.contains("“") && expression.contains("”")) {
            updatedExpression = updatedExpression.replacingOccurrences(of: "” ", with: "”").replacingOccurrences(of: " “", with: "“")
            calculate.setText(text: updatedExpression)
            let calculatedValue = try calculate.compareString()
            if expression.contains("“") && expression.contains("”") {
                self.solvedExpression = "“" +  calculatedValue + "”"
            } else {
                self.solvedExpression = calculatedValue
            }

        } else if (expression.contains("“") || expression.contains("”")) && (type == .int || type == .double || type == .bool) {
            updatedExpression = updatedExpression.replacingOccurrences(of: "true", with: "1").replacingOccurrences(of: "false", with: "0")
                    .replacingOccurrences(of: "“", with: "").replacingOccurrences(of: "”", with: "")
            calculate.setText(text: updatedExpression)
            let calculatedValue = try calculate.compare()

            if type == .int {
                self.solvedExpression = String(Int(calculatedValue))
            } else if type == .double {
                self.solvedExpression = String(Double(calculatedValue))
            } else if type == .bool {
                self.solvedExpression = calculatedValue == 0 ? "false" : "true"
            } else {
                self.solvedExpression = ""
            }
        }
        else if expression.contains("“") || expression.contains("”"){
            throw ErrorType.invalidTokenTypeError
        } else if type == .bool || type == .int || type == .double || type == .string {
            updatedExpression = updatedExpression.replacingOccurrences(of: "true", with: "1").replacingOccurrences(of: "false", with: "0")
            calculate.setText(text: updatedExpression)
            let calculatedValue = try calculate.compare()

            if type == .int {
                self.solvedExpression = String(Int(calculatedValue))
            } else if type == .double {
                self.solvedExpression = String(Double(calculatedValue))
            } else if type == .bool {
                self.solvedExpression = calculatedValue == 0 ? "false" : "true"
            } else if type == .string {
                self.solvedExpression = "“" + String(calculatedValue) + "”"
            } else {
                self.solvedExpression = ""
            }
        }
         else {
            self.solvedExpression =  expression
        }
    }

}