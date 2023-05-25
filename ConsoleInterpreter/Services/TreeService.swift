import Foundation


class Tree {
    var rootNode: Node = Node(value: "", type: AllTypes.root, id: 0)
    var index: Int = 0
    var blocks = [IBlock]()

    init() {

    }

    func setBlocks(_ blocks: [IBlock]) {
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
            case let printBlock as Output:
                let printingNode = buildPrintingNode(printing: printBlock)
                rootNode.addChild(printingNode)
                index += 1
            case let readBlock as ReadingData:
                let readingNode = buildReadingNode(reading: readBlock)
                rootNode.addChild(readingNode)
                index += 1
            case is Loop:
                if let loopNode = buildNode(getBlockAndMoveIndex(),
                        type: determineLoopBlock(block) ?? AllTypes.forLoop) {
                    rootNode.addChild(loopNode)
                }
            case is Condition:
                if let conditionNode = buildNode(getBlockAndMoveIndex(),
                        type: determineConditionBlock(block) ?? AllTypes.ifBlock) {
                    rootNode.addChild(conditionNode)
                }
            case let readBlock as Flow:
                if readBlock.type == FlowType.continueFlow {
                    if let continueNode = buildContinue(block) {
                        rootNode.addChild(continueNode)
                    }
                } else if readBlock.type == FlowType.breakFlow {
                    if let breakNode = buildBreak(block) {
                        rootNode.addChild(breakNode)
                    }
                }
                index += 1
            case is Function:
                if let functionNode = buildNode(getBlockAndMoveIndex(),
                        type: AllTypes.function) {
                    rootNode.addChild(functionNode)
                }
            case let methodBlock as MethodsOfList:
                let methodNode = buildMethodsOfList(method: methodBlock)
                rootNode.addChild(methodNode)
                index += 1
            default:
                index += 1

            }
        }
    }

    private func buildReadingNode(reading: ReadingData) -> Node {
        let node = Node(value: reading.value, type: AllTypes.cin,
                id: reading.id, isDebug: reading.isDebug)
        return node
    }

    private func buildMethodsOfList(method: MethodsOfList) -> Node {
        let node = Node(value: method.value, type: determineMethod(method: method) ?? AllTypes.append,
                id: method.id, isDebug: method.isDebug)
        return node
    }

    private func determineMethod(method: MethodsOfList) -> AllTypes? {
        switch method.type {
        case .append:
            return AllTypes.append
        case .remove:
            return AllTypes.remove
        case .pop:
            return AllTypes.pop
        }
    }

    private func buildBreak(_ block: IBlock) -> Node? {
        if let breakBlock = block as? Flow {
            if (breakBlock.type != FlowType.breakFlow) {
                return nil
            }
            let node = Node(value: "", type: AllTypes.breakBlock,
                    id: breakBlock.id, isDebug: breakBlock.isDebug)
            return node
        }
        return nil
    }

    private func buildContinue(_ block: IBlock) -> Node? {
        if let continueBlock = block as? Flow {
            if (continueBlock.type != FlowType.continueFlow) {
                return nil
            }
            let node = Node(value: "", type: AllTypes.continueBlock,
                    id: continueBlock.id, isDebug: continueBlock.isDebug)
            return node
        }
        return nil
    }

    private func getMatchingDelimiterIndex() -> Int? {
        var countBegin = 0
        for i in (index + 1)..<blocks.count {
            guard let block = blocks[i] as? Flow else {
                continue
            }
            countBegin += countForMatchingDelimiter(block)
            if countBegin == 0 {
                return i
            }
        }
        return nil
    }

    private func countForMatchingDelimiter(_ block: Flow) -> Int {
        if isEndDelimiter(block) {
            return -1
        } else if isBeginDelimiter(block) {
            return 1
        }
        return 0
    }

    private func isBeginDelimiter(_ block: Flow) -> Bool {
        block.type == FlowType.begin
    }

    private func isEndDelimiter(_ block: Flow) -> Bool {
        block.type == FlowType.end
    }


    private func getBlockAndMoveIndex() -> [IBlock] {
        var wholeBlock: [IBlock] = []
        guard let endIndex = getMatchingDelimiterIndex() else {
            return wholeBlock
        }
        wholeBlock.append(blocks[index])
        wholeBlock += Array(blocks[(index + 1)...endIndex])
        index = endIndex + 1
        return wholeBlock
    }

    private func buildVariableNode(variable: Variable) -> Node {
        let node = Node(value: variable.type.rawValue, type: AllTypes.assign,
                id: variable.id, isDebug: variable.isDebug)
        let nameVariable = Node(value: variable.name, type: .variable(type: variable.type),
                id: variable.id)
        let valueVariable = Node(value: variable.value, type: AllTypes.arithmetic,
                id: variable.id)
        node.addChild(nameVariable)
        node.addChild(valueVariable)
        return node
    }


    private func buildPrintingNode(printing: Output) -> Node {
        let node = Node(value: printing.value, type: AllTypes.print,
                id: printing.id, isDebug: printing.isDebug)
        return node
    }

    private func determineLoopBlock(_ block: IBlock) -> AllTypes? {
        if let loop = block as? Loop {
            if loop.type == LoopType.forLoop {
                return AllTypes.forLoop
            } else if loop.type == LoopType.whileLoop {
                return AllTypes.whileLoop
            }
        }
        return nil
    }

    private func determineConditionBlock(_ block: IBlock) -> AllTypes? {
        if let condition = block as? Condition {
            if condition.type == ConditionType.ifBlock {
                return AllTypes.ifBlock
            } else if condition.type == ConditionType.elifBlock {
                return AllTypes.elifBlock
            } else if condition.type == ConditionType.elseBlock {
                return AllTypes.elseBlock
            }
        }
        return nil
    }

    private func buildFirstNode(_ type: AllTypes, _ firstBlock: IBlock) -> Node? {
        var node: Node?
        if let condition = firstBlock as? Condition {
            switch type {
            case .ifBlock:
                node = Node(value: condition.value, type: .ifBlock, id: condition.id, isDebug: condition.isDebug)
            case .elifBlock:
                node = Node(value: condition.value, type: .elifBlock, id: condition.id, isDebug: condition.isDebug)
            case .elseBlock:
                node = Node(value: condition.value, type: .elseBlock, id: condition.id, isDebug: condition.isDebug)
            default:
                return nil
            }
        } else if let loop = firstBlock as? Loop {
            if type == .forLoop || type == .whileLoop {
                node = Node(value: loop.value, type: type, id: loop.id, isDebug: loop.isDebug)
            } else {
                return nil
            }
        } else if let function = firstBlock as? Function {
            if type == .function {
                node = Node(value: function.value, type: type, id: function.id, isDebug: function.isDebug)
            } else {
                return nil
            }
        }
        return node
    }


    private func buildNode(_ block: [IBlock], type: AllTypes) -> Node? {
        guard let firstBlock = block.first else {
            return nil
        }

        let node = buildFirstNode(type, firstBlock)
        var index = 1

        while index < block.count {
            if let flowBlock = block[index] as? Flow {
                if flowBlock.type == FlowType.continueFlow {
                    let continueNode = buildContinue(flowBlock) ?? Node(value: "",
                            type: AllTypes.continueBlock, id: flowBlock.id,
                            isDebug: flowBlock.isDebug)
                    node?.addChild(continueNode)
                } else if flowBlock.type == FlowType.breakFlow {
                    let breakNode = buildBreak(flowBlock) ?? Node(value: "",
                            type: AllTypes.breakBlock, id: flowBlock.id,
                            isDebug: flowBlock.isDebug)
                    node?.addChild(breakNode)
                }
                index += 1
                continue
            } else if let variableBlock = block[index] as? Variable {
                let variableNode = buildVariableNode(variable: variableBlock)
                node?.addChild(variableNode)
            } else if let printBlock = block[index] as? Output {
                let printingNode = buildPrintingNode(printing: printBlock)
                node?.addChild(printingNode)
            } else if let method = block[index] as? MethodsOfList {
                let methodNode = buildMethodsOfList(method: method)
                node?.addChild(methodNode)
            } else if let readingDataBlock = block[index] as? ReadingData {
                let readingDataNode = Node(value: readingDataBlock.value,
                        type: .cin, id: readingDataBlock.id,
                        isDebug: readingDataBlock.isDebug)
                node?.addChild(readingDataNode)
            } else if let returnBlock = block[index] as? Returning {
                let returnNode = Node(value: returnBlock.value,
                        type: .returnFunction, id: returnBlock.id,
                        isDebug: returnBlock.isDebug)
                node?.addChild(returnNode)
            } else if let nestedConditionBlock = block[index] as? Condition {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedConditionBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? Flow {
                        if blockEnd.type == FlowType.continueFlow ||
                                   blockEnd.type == FlowType.breakFlow {
                            nestedBlocks.append(block[additionIndex])
                        }

                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let typeCondition = determineConditionBlock(nestedConditionBlock) {
                    if let nestedNode = buildNode(nestedBlocks, type: typeCondition) {
                        node?.addChild(nestedNode)
                    }
                }

                index = additionIndex
            } else if let nestedBlock = block[index] as? Flow {
                if nestedBlock.type == FlowType.breakFlow {
                    let breakNode = Node(value: "", type: .breakBlock,
                            id: nestedBlock.id, isDebug: nestedBlock.isDebug)
                    node?.addChild(breakNode)
                } else if nestedBlock.type == FlowType.continueFlow {
                    let continueNode = Node(value: "", type: .continueBlock,
                            id: nestedBlock.id, isDebug: nestedBlock.isDebug)
                    node?.addChild(continueNode)
                }
                index += 1
            } else if let nestedLoopBlock = block[index] as? Loop {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedLoopBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? Flow {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let typeLoop = determineLoopBlock(nestedLoopBlock) {
                    if let nestedNode = buildNode(nestedBlocks, type: typeLoop) {
                        node?.addChild(nestedNode)
                    }
               }
                index = additionIndex
            } else if let nestedFunctionBlock = block[index] as? Function {
                var nestedBlocks: [IBlock] = []
                var additionIndex = index + 1
                nestedBlocks.append(nestedFunctionBlock)
                var countBegin: Int = 0
                while additionIndex < block.count {
                    if let blockEnd = block[additionIndex] as? Flow {
                        countBegin += countForMatchingDelimiter(blockEnd)
                        if countBegin == 0 {
                            break
                        }
                    }
                    nestedBlocks.append(block[additionIndex])
                    additionIndex += 1
                }
                if let nestedNode = buildNode(nestedBlocks, type: .function) {
                    node?.addChild(nestedNode)
                }
                index = additionIndex
            }
            index += 1
        }
        return node
    }
}
