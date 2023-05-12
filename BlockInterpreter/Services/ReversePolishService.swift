import Foundation


// "-2" унарный минус пишем слитно, бинарный раздельно "- 2"
// пробелы влияют на результат

class ReversePolishNotation {
    private let operators = Set(["+", "-", "*", "/", ">", "<", "==", "!=", ">=", "<=", "&&", "||"])
    private let precedence = [
        "+": 1,
        "-": 1,
        "*": 2,
        "/": 2,
        ">": 0,
        "<": 0,
        "==": 0,
        "!=": 0,
        ">=": 0,
        "<=": 0,
        "&&": -1,
        "||": -1
    ]

    func toPostfix(_ input: String) -> String {
        var output = ""
        var stack = [String]()
        var lastToken = ""

        for token in input.replacingOccurrences(of: "--", with: "").components(separatedBy: " ") {
            switch token {
            case let number where Int(number) != nil:
                output += "\(number) "
            case "(":
                stack.append(token)
            case ")":
                while let last = stack.last, last != "(", !stack.isEmpty {
                    output += "\(stack.removeLast()) "
                }
                stack.removeLast()
            case "+", "-", "*", "/", ">", "<", "==", "!=", ">=", "<=", "&&", "||":
                handleOperator(token: token, stack: &stack, output: &output, lastToken: lastToken)
            default:
                output += "\(token) "
            }
            lastToken = token
        }

        while !stack.isEmpty {
            output += "\(stack.removeLast()) "
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func handleOperator(token: String, stack: inout [String], output: inout String, lastToken: String) {
        if token == "-" && (lastToken == "" || isOperator(lastToken) && lastToken != ")") {
            stack.append("0")
        }

        while let last = stack.last, isOperator(last), precedence[token]! <= precedence[last]! {
            output += "\(stack.removeLast()) "
        }

        stack.append(token)
    }

    private func isOperator(_ token: String) -> Bool {
        return operators.contains(token)
    }
}

