import Foundation

class ExpressionSolver{
    private var expression: String
    private var type: VariableType
    public var solvedExpression: String

    init(_ expression: String, _ type: VariableType) {
        self.expression = expression
        self.type = type
        self.solvedExpression = ""
        updateSolvedExpression()
    }

    private func updateSolvedExpression(){
        let calculate = Calculate("")

        if type == .String {
            let updatedExpression = expression.replacingOccurrences(of: "“", with: "").replacingOccurrences(of: "”", with: "")
            calculate.setText(text: updatedExpression)
            let calculatedValue = calculate.compareString()
            if expression.contains("“") && expression.contains("”") && calculatedValue != "false" && calculatedValue != "true"{
                self.solvedExpression = "“" +  calculatedValue + "”"
            } else {
                self.solvedExpression = calculatedValue
            }
        } else {
            calculate.setText(text: expression)
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