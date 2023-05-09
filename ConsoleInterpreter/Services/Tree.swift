import Foundation


class Tree {
    var rootNode: Node = Node(value: "Begin", type: AllTypes.root)
    
    init() {
    }
    
    func buildTree<T>(blocks: [T]) {
        var index: Int = 0;
        
        while (index < blocks.count) {
            if let variableBlock = blocks[index] as? Variable {
                let variableNode = buildVariableNode(variable: variableBlock)
                rootNode.addChild(variableNode)
                index += 1
            } else if let printBlock = blocks[index] as? Printing {
                let printingNode = buildPrintingNode(printing: printBlock)
                rootNode.addChild(printingNode)
                index += 1
            } else if let conditionBlock = blocks[index] as? Condition {
                var array: [Any] = []
                var additionIndex: Int = index + 1
                array.append(blocks[index])
                while (additionIndex < blocks.count) {
                    if let blockEnd = blocks[additionIndex] as? BlockDelimiter {
                        if (blockEnd.type == DelimiterType.end) {
                            break
                        }
                    }
                    array.append(blocks[additionIndex])
                    additionIndex += 1
                }
                
                var indAdd: Int = 0
                var countIf: Int = 0
                while (indAdd < array.count) {
                    if let conditionBlockOpt = array[indAdd] as? Condition {
                        countIf += 1
                    }
                    indAdd += 1
                }
                index = additionIndex
                index += (countIf - 1)
                let conditionNode = buildConditionNode(array)
                if let conditionNode = conditionNode {
                    rootNode.addChild(conditionNode)
                }
                index += 1
            }
        }
    }
    
    private func buildVariableNode(variable: Variable) -> Node {
        let node = Node(value: "", type: AllTypes.assign)
        let nameVariable = Node(value: variable.name, type: AllTypes.variable)
        let valueVariable = Node(value: variable.value, type: AllTypes.arithmetic)
        node.addChild(nameVariable)
        node.addChild(valueVariable)
        return node
    }
    
    
    private func buildPrintingNode(printing: Printing) -> Node {
        let node = Node(value: printing.value, type: AllTypes.print)
        return node
    }
    
    private func buildConditionNode<T>(_ conditionBlock: [T]) -> Node? {
        guard let condition = conditionBlock.first as? Condition else {
            return nil
        }
        let node = Node(value: condition.value, type: AllTypes.ifBlock)
        var index = 1
        
        while index < conditionBlock.count {
            if let block = conditionBlock[index] as? BlockDelimiter {
                if block.type == DelimiterType.end {
                    break
                }
            } else if let nestedConditionBlock = conditionBlock[index] as? [T] {
                if let nestedNode = buildConditionNode(nestedConditionBlock) {
                    node.addChild(nestedNode)
                }
            } else if let variableBlock = conditionBlock[index] as? Variable {
                let variableNode = buildVariableNode(variable: variableBlock)
                node.addChild(variableNode)
            } else if let printBlock = conditionBlock[index] as? Printing {
                let printingNode = buildPrintingNode(printing: printBlock)
                node.addChild(printingNode)
            } else if let nestedConditionBlock = conditionBlock[index] as? Condition {
                var nestedBlocks: [Any] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedConditionBlock)
                while additionIndex < conditionBlock.count {
                    if let blockEnd = conditionBlock[additionIndex] as? BlockDelimiter {
                        if blockEnd.type == DelimiterType.end {
                            break
                        }
                    }
                    nestedBlocks.append(conditionBlock[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildConditionNode(nestedBlocks) {
                    node.addChild(nestedNode)
                }
                index = additionIndex
                continue
            }
            index += 1
        }
        return node
    }
    
}
