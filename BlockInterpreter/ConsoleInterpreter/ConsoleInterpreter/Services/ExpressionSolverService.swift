import Foundation

class ExpressionSolver{
    private var expression: String
    private var type: VariableType
    private var solvedExpression: String

    init() {
        self.solvedExpression = ""
        self.expression = ""
        self.type = .int
    }

    public func getSolvedExpression() -> String {
        return solvedExpression
    }

    public func setExpressionAndType(_ expression: String, _ type: VariableType) {
        self.expression = expression
        self.type = type
        updateSolvedExpression()
    }

    private func updateSolvedExpression(){
        let calculate = Calculate("")

        var updatedExpression = expression
        if type == .String || (expression.contains("“") && expression.contains("”")) {
            updatedExpression = updatedExpression.replacingOccurrences(of: "” ", with: "”").replacingOccurrences(of: " “", with: "“")
            calculate.setText(text: updatedExpression)
            let calculatedValue = calculate.compareString()
            if expression.contains("“") && expression.contains("”") {
                self.solvedExpression = "“" +  calculatedValue + "”"
            } else {
                self.solvedExpression = calculatedValue
            }

        } else if expression.contains("“") || expression.contains("”") || expression.contains("[") || expression.contains("]"){
            fatalError("Invalid type")
        } else {
            updatedExpression = updatedExpression.replacingOccurrences(of: "true", with: "1").replacingOccurrences(of: "false", with: "0")
            calculate.setText(text: updatedExpression)

            let calculatedValue = calculate.compare()

            if type == .int {
                self.solvedExpression =  String(calculatedValue)
            } else if type == .double {
                self.solvedExpression = String(Double(calculatedValue))
            } else if type == .bool {
                self.solvedExpression = calculatedValue == 0 ? "false" : "true"
            } else {
                self.solvedExpression =  ""
            }
        }

    }

}