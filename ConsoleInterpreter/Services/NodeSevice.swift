import Foundation


enum AllTypes: Equatable {
    case assign
    case ifBlock
    case elifBlock
    case elseBlock
    case forLoop
    case whileLoop
    case function
    case returnFunction
    case variable(type: VariableType)
    case arithmetic
    case print
    case root
    case breakBlock
    case continueBlock
    case cin
    case append
    case pop
    case remove

    static func ==(lhs: AllTypes, rhs: AllTypes) -> Bool {
        switch (lhs, rhs) {
        case (.assign, .assign):
            return true
        case (.ifBlock, .ifBlock):
            return true
        case (.elifBlock, .elifBlock):
            return true
        case (.elseBlock, .elseBlock):
            return true
        case (.forLoop, .forLoop):
            return true
        case (.whileLoop, .whileLoop):
            return true
        case (.function, .function):
            return true
        case (.returnFunction, .returnFunction):
            return true
        case (.variable(_), .variable(_)):
            return  true
        case (.arithmetic, .arithmetic):
            return true
        case (.print, .print):
            return true
        case (.root, .root):
            return true
        case (.breakBlock, .breakBlock):
            return true
        case (.continueBlock, .continueBlock):
            return true
        case (.cin, .cin):
            return true
        case (.append, .append):
            return true
        case (.pop, .pop):
            return true
        case (.remove, .remove):
            return true
        default:
            return false
        }
    }
}


class Node {
    private(set) var value: String
    private(set) var type: AllTypes
    private(set) var parent: Node?
    private(set) var children: [Node]
    private var countWasHere: Int
    private(set) var id: Int
    private(set) var isDebug: Bool

    init(value: String, type: AllTypes, id: Int, isDebug: Bool = false) {
        self.value = value
        self.type = type
        self.id = id
        self.isDebug = isDebug
        countWasHere = 0
        children = []
    }

    func addChild(_ child: Node) {
        children.append(child)
        child.parent = self
    }
    func getCountWasHere() -> Int {
        return countWasHere
    }
    func setCountWasHere(_ countWasHere: Int) {
        self.countWasHere = countWasHere
    }
}