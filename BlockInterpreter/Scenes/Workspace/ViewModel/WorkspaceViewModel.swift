//
//  WorkspaceViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class WorkspaceViewModel: WorkspaceViewModelType {
    
    var didEnableEditingMode = PassthroughSubject<Void, Never>()
    var didDeleteRows = PassthroughSubject<[IndexPath], Never>()
    var didUpdateBlocksTable = PassthroughSubject<Void, Never>()
    var didFinishEditingBlocks = PassthroughSubject<Void, Never>()
    
    var showConsole = PassthroughSubject<Void, Never>()
    var saveAlgorithm = PassthroughSubject<(String?, Data?), Never>()
    var deleteAllBlocks = PassthroughSubject<Void, Never>()
    var didBeginEditingBlocks = PassthroughSubject<Void, Never>()
    var removeBlock = PassthroughSubject<BlockCellViewModel, Never>()
    var addBlocks = PassthroughSubject<[BlockCellViewModel], Never>()
    var moveBlock = PassthroughSubject<(from: IndexPath, to: IndexPath), Never>()
    
    var isWiggleMode = CurrentValueSubject<Bool, Never>(false)
    var isIntroHidden = CurrentValueSubject<Bool, Never>(false)
    
    var cellViewModels = CurrentValueSubject<[BlockCellViewModel], Never>([])
    
    var optionTitle = "Delete all blocks"
    var introTitle = "Create your first code block!"
    private var subscriptions = Set<AnyCancellable>()
    private(set) var didGoToConsole = PassthroughSubject<String, Never>()
    private(set) var didShowSavedAlgorithm = PassthroughSubject<[IBlock], Never>()
    
    private let algorithmRepository: AlgorithmRepository
    private let interpreterManager: InterpreterManager
    
    init(interpreterManager: InterpreterManager, algorithmRepository: AlgorithmRepository) {
        self.interpreterManager = interpreterManager
        self.algorithmRepository = algorithmRepository
        bind()
    }
    
}

extension WorkspaceViewModel  {
    private func getBlocks() -> [IBlock] {
        var blocks = [IBlock]()
        
        for (index, blockViewModel) in cellViewModels.value.enumerated() {
            switch blockViewModel {
            case let variableBlockViewModel as VariableBlockCellViewModel:
                blocks.append(Variable(id: index,
                                       type: variableBlockViewModel.variableType,
                                       name: variableBlockViewModel.variableName ?? "",
                                       value: variableBlockViewModel.variableValue ?? ""))
                
            case let conditionBlockViewModel as ConditionBlockCellViewModel:
                blocks.append(Condition(id: index,
                                        type: conditionBlockViewModel.conditionType,
                                        value: conditionBlockViewModel.conditionText ?? ""))
                
            case let flowBlockViewModel as FlowBlockCellViewModel:
                blocks.append(Flow(id: index, type: flowBlockViewModel.flowType))
                
            case let outputBlockViewModel as OutputBlockCellViewModel:
                blocks.append(Output(id: index,
                                     type: outputBlockViewModel.outputType,
                                     value: outputBlockViewModel.outputValue ?? ""))
                
            case let whileLoopBlockViewModel as WhileLoopBlockCellViewModel:
                blocks.append(Loop(id: index,
                                   type: .whileLoop,
                                   value: whileLoopBlockViewModel.loopCondition ?? ""))
                
            case let forLoopBlockViewModel as ForLoopBlockCellViewModel:
                blocks.append(Loop(id: index,
                                   type: .forLoop,
                                   value: forLoopBlockViewModel.loopValue))
                
            case let arrayMethodViewModel as ArrayMethodBlockCellViewModel:
                blocks.append(ArrayMethod(id: index,
                                            type: arrayMethodViewModel.methodType,
                                            name: arrayMethodViewModel.arrayName ?? "",
                                            value: arrayMethodViewModel.value ?? "",
                                            isDebug: false))
            case let returningViewModel as ReturningBlockCellViewModel:
                blocks.append(Returning(id: index, value: returningViewModel.returnValue ?? ""))
                
            default: break
            }
        }

        
        return blocks
    }
    
    private func updateBlockViewModels(_ blocks: [IBlock]) {
        var updatedCellViewModels = [BlockCellViewModel]()
        
        for block in blocks {
            switch block {
            case let block as Returning:
                updatedCellViewModels.append(ReturningBlockCellViewModel(style: .presentation))
                
            case let block as Function:
                updatedCellViewModels.append(FunctionBlockCellViewModel(returnType: .arrayString, style: .work))
            case let block as Variable:
                updatedCellViewModels.append(VariableBlockCellViewModel(blockType: .assignment,
                                                                        variableType: block.type,
                                                                        style: .work))
                
            case let block as Condition:
                updatedCellViewModels.append(ConditionBlockCellViewModel(conditionType: block.type,
                                                                         style: .work))
                
            case let block as Output:
                updatedCellViewModels.append(OutputBlockCellViewModel(outputType: block.type, style: .work))
                
            case let block as Flow:
                updatedCellViewModels.append(FlowBlockCellViewModel(flowType: block.type,
                                                                    style: .work))
                
            case let block as Loop:
                
                if block.type == .forLoop {
                    updatedCellViewModels.append(ForLoopBlockCellViewModel(style: .work))
                } else {
                    updatedCellViewModels.append(WhileLoopBlockCellViewModel(style: .work))
                }
                
            case let block as ArrayMethod:
                updatedCellViewModels.append(ArrayMethodBlockCellViewModel(methodType: block.type,
                                                                           style: .work))
                
            default: continue
            }
        }
        
        cellViewModels.value = updatedCellViewModels
    }
    
    private func getConsoleContent() -> String {
        let output = interpreterManager.getConsoleContent(blocks: getBlocks())
        print("Output = \(output)")
        
        return output
    }
    
    private func bind() {
        showConsole
            .sink { [weak self] in
                guard let self = self else { return }
                didGoToConsole.send(getConsoleContent())
            }
            .store(in: &subscriptions)
        
        moveBlock
            .sink { [weak self] in
                guard let self = self else { return }
                cellViewModels.value.insert(cellViewModels.value.remove(at: $0.from.row), at: $0.to.row)
            }
            .store(in: &subscriptions)
        
        addBlocks
            .map { $0.map { $0.copyToWork() } }
            .sink { [weak self] in
                guard let self = self else { return }
                
                cellViewModels.value.append(contentsOf: $0 )
                didUpdateBlocksTable.send()
            }
            .store(in: &subscriptions)
        
        deleteAllBlocks
            .sink { [weak self] in
                guard let self = self else { return }
                
                cellViewModels.value.removeAll()
                didUpdateBlocksTable.send()
            }
            .store(in: &subscriptions)
        
        removeBlock
            .sink { [weak self] cellViewModel in
                guard
                    let self = self,
                    let index = cellViewModels.value.firstIndex(where: { cellViewModel === $0 })
                else { return }
                
                cellViewModels.value.remove(at: index)
                didDeleteRows.send([IndexPath(row: index, section: 0)])
            }
            .store(in: &subscriptions)
        
        isWiggleMode
            .sink { [weak self] value in
                self?.cellViewModels.value.forEach { $0.isWiggleMode = value }
            }
            .store(in: &subscriptions)
        
        cellViewModels
            .sink { [weak self] in
                guard let self = self else { return }
                
                if $0.count == 0 {
                    isWiggleMode.send(false)
                    isIntroHidden.send(false)
                } else if !isIntroHidden.value {
                    isIntroHidden.send(true)
                }
            }
            .store(in: &subscriptions)
        
        didBeginEditingBlocks
            .sink { [weak self] in
                guard let self = self else { return }
                guard cellViewModels.value.isEmpty == false else { return }
                
                isWiggleMode.send(true)
            }
            .store(in: &subscriptions)
        
        saveAlgorithm
            .sink { [weak self] docName, imageData in
                guard
                    let self = self,
                    let docName = docName,
                    let imageData = imageData
                else { return }
                
                let algorithm = Algorithm(name: docName, imageData: imageData, blocks: getBlocks())
                print("algorithm.variables - \(algorithm.getBlocks())")
                algorithmRepository.addAlgorithm.send(algorithm)
            }
            .store(in: &subscriptions)
        
        didShowSavedAlgorithm
            .sink { [weak self] in
                guard let self = self else { return }
                
                updateBlockViewModels($0)
                didUpdateBlocksTable.send()
            }
            .store(in: &subscriptions)
    }
}
