import Foundation
 
 
var mapOfVariablesInt: [String: String] = [:]
 
 
var variableForInt = Variable(id: 1, type: TypeVariable.int,
                              value: "12 + 15", name: "a")
var assignVariableInt = AssignmentVariableInt(mapOfVariablesInt)
var nameAndValueOfVariable = assignVariableInt.assignInt(variable: variableForInt)
mapOfVariablesInt[nameAndValueOfVariable.0] = nameAndValueOfVariable.1
print(mapOfVariablesInt)
 
 
variableForInt = Variable(id: 2, type: TypeVariable.int,
                          value: "a / 3", name: "b")
assignVariableInt = AssignmentVariableInt(mapOfVariablesInt)
nameAndValueOfVariable = assignVariableInt.assignInt(variable: variableForInt)
mapOfVariablesInt[nameAndValueOfVariable.0] = nameAndValueOfVariable.1
print(mapOfVariablesInt)

