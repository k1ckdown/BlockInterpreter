import Foundation


class Tree {
    var rootNode: Node = Node(value: "Begin", type: AllTypes.root)
    var index: Int = 0
    var blocks: [Any]
    init(_ blocks: [Any]) {
        self.blocks = blocks
    }

    func buildTree() {
        while index < blocks.count {
            let block = blocks[index]
            switch block {
            case let variableBlock as Variable:
                let variableNode = buildVariableNode(variable: variableBlock)
                rootNode.addChild(variableNode)
                index += 1
            case let printBlock as Printing:
                let printingNode = buildPrintingNode(printing: printBlock)
                rootNode.addChild(printingNode)
                index += 1
            case is Loop:
                if let loopNode = buildLoopNode(getBlockAndMoveIndex()) {
                    rootNode.addChild(loopNode)
                }
            case is Condition:
                if let conditionNode = buildConditionNode(getBlockAndMoveIndex()) {
                    rootNode.addChild(conditionNode)
                }
            case is BlockDelimiter:
                index += 1
            default:
                index += 1
            }
        }
    }

    private func getMatchingDelimiterIndex() -> Int? {
        var countBegin = 0
        for i in (index + 1)..<blocks.count {
            guard let block = blocks[i] as? BlockDelimiter else {
                continue
            }
            countBegin += countForMatchingDelimiter(block)
            if countBegin == 0 {
                return i
            }
        }
        return nil
    }

    private func countForMatchingDelimiter(_ block: BlockDelimiter) -> Int {
        if isEndDelimiter(block) {
            return -1
        } else if isBeginDelimiter(block) {
            return 1
        }
        return 0
    }

    private func isBeginDelimiter(_ block: BlockDelimiter) -> Bool {
        block.type == DelimiterType.begin
    }

    private func isEndDelimiter(_ block: BlockDelimiter) -> Bool {
        block.type == DelimiterType.end
    }


    private func getBlockAndMoveIndex() -> [Any] {
        var wholeBlock: [Any] = []
        guard let endIndex = getMatchingDelimiterIndex() else {
            return wholeBlock
        }
        wholeBlock.append(blocks[index])
        wholeBlock += Array(blocks[(index + 1)...endIndex])
        index = endIndex + 1
        return wholeBlock
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
                index += 1
                continue
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
                var countBegin: Int = 0
                while additionIndex < conditionBlock.count {
                    if let blockEnd = conditionBlock[additionIndex] as? BlockDelimiter {
                        if blockEnd.type == DelimiterType.end {
                            countBegin -= 1
                            if countBegin == 0 {
                                break
                            }
                        }
                        else if blockEnd.type == DelimiterType.begin {
                            countBegin += 1
                        }
                    }
                    nestedBlocks.append(conditionBlock[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildConditionNode(nestedBlocks) {
                    node.addChild(nestedNode)
                }
                index = additionIndex
            } else if let loopBlock = conditionBlock[index] as? Loop {
                var loopBlocks: [Any] = []
                var additionIndex = index + 1
                loopBlocks.append(loopBlock)
                var countBegin: Int = 0
                while additionIndex < conditionBlock.count {
                    if let blockEnd = conditionBlock[additionIndex] as? BlockDelimiter {
                        if blockEnd.type == DelimiterType.end {
                            countBegin -= 1
                            if countBegin == 0 {
                                break
                            }
                        }
                        else if blockEnd.type == DelimiterType.begin {
                            countBegin += 1
                        }
                    }
                    loopBlocks.append(conditionBlock[additionIndex])
                    additionIndex += 1
                }
                if let loopNode = buildLoopNode(loopBlocks) {
                    node.addChild(loopNode)
                }
                index = additionIndex
            }
            index += 1
        }
        return node
    }

    private func buildLoopNode<T>(_ loopBlock: [T]) -> Node? {
        guard let loop = loopBlock.first as? Loop else {
            return nil
        }
        let node = Node(value: loop.value, type: AllTypes.loop)
        var index = 1

        while index < loopBlock.count {
            if let block = loopBlock[index] as? BlockDelimiter {
                index += 1
                continue
            } else if let variableBlock = loopBlock[index] as? Variable {
                let variableNode = buildVariableNode(variable: variableBlock)
                node.addChild(variableNode)
            } else if let printBlock = loopBlock[index] as? Printing {
                let printingNode = buildPrintingNode(printing: printBlock)
                node.addChild(printingNode)
            } else if let nestedConditionBlock = loopBlock[index] as? Condition {
                var nestedBlocks: [Any] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedConditionBlock)
                var countBegin: Int = 0
                while additionIndex < loopBlock.count {
                    if let blockEnd = loopBlock[additionIndex] as? BlockDelimiter {
                        if blockEnd.type == DelimiterType.end {
                            countBegin -= 1
                            if countBegin == 0 {
                                break
                            }
                        }
                        else if blockEnd.type == DelimiterType.begin {
                            countBegin += 1
                        }
                    }
                    nestedBlocks.append(loopBlock[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildConditionNode(nestedBlocks) {
                    node.addChild(nestedNode)
                }
                index = additionIndex
            }
            else if let nestedLoopBlock = loopBlock[index] as? Loop {
                var nestedBlocks: [Any] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedLoopBlock)
                var countBegin: Int = 0
                while additionIndex < loopBlock.count {
                    if let blockEnd = loopBlock[additionIndex] as? BlockDelimiter {
                        if blockEnd.type == DelimiterType.end {
                            countBegin -= 1
                            if countBegin == 0 {
                                break
                            }
                        }
                        else if blockEnd.type == DelimiterType.begin {
                            countBegin += 1
                        }
                    }
                    nestedBlocks.append(loopBlock[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildLoopNode(nestedBlocks) {
                    node.addChild(nestedNode)
                }
                index = additionIndex
            }
            index += 1
        }

        return node
    }
}
