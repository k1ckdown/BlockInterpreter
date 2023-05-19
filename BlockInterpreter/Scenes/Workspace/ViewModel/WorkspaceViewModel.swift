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
    var isWiggleMode = CurrentValueSubject<Bool, Never>(false)
    var didBeginEditingBlocks = PassthroughSubject<Void, Never>()
    var removeBlock = PassthroughSubject<BlockCellViewModel, Never>()
    var addBlocks = PassthroughSubject<[BlockCellViewModel], Never>()
    var moveBlock = PassthroughSubject<(IndexPath, IndexPath), Never>()
    
    var cellViewModels = [BlockCellViewModel]()
    
    private var subscriptions = Set<AnyCancellable>()
    private(set) var didGoToConsole = PassthroughSubject<String, Never>()
    
    private let interpreterManager: InterpreterManager
    
    init(interpreterManager: InterpreterManager) {
        self.interpreterManager = interpreterManager
        bind()
    }
    
}

extension WorkspaceViewModel  {
    private func getBlocks() -> [IBlock] {
        var blocks = [IBlock]()
        
        for (index, blockViewModel) in cellViewModels.enumerated() {
            if let variableBlockViewModel = blockViewModel as? VariableBlockCellViewModel {
                blocks.append(Variable(id: index,
                                       type: variableBlockViewModel.variableType ?? .int,
                                       name: variableBlockViewModel.variableName ?? "",
                                       value: variableBlockViewModel.variableValue ?? ""))
                
            } else if let conditionBlockViewModel = blockViewModel as? ConditionBlockCellViewModel {
                blocks.append(Condition(id: index,
                                        type: conditionBlockViewModel.conditionType,
                                        value: conditionBlockViewModel.conditionText ?? ""))
                
            } else if let flowBlockViewModel = blockViewModel as? FlowBlockCellViewModel {
                blocks.append(Flow(type: flowBlockViewModel.flowType))
                
            } else if let outputBlockViewModel = blockViewModel as? OutputBlockCellViewModel {
                blocks.append(Output(id: index,
                                       value: outputBlockViewModel.outputValue ?? ""))
                
            } else if let whileLoopViewModel = blockViewModel as? WhileLoopBlockCellViewModel {
                blocks.append(Loop(id: index,
                                   type: .whileLoop,
                                   value: whileLoopViewModel.loopCondition ?? ""))
                
            } else if let forLoopViewModel = blockViewModel as? ForLoopBlockCellViewModel {
                blocks.append(Loop(id: index,
                                   type: .forLoop,
                                   value: forLoopViewModel.loopValue))
            }
            
        }
        
        return blocks
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
                cellViewModels.insert(cellViewModels.remove(at: $0.0.row), at: $0.1.row)
            }
            .store(in: &subscriptions)
        
        addBlocks
            .map { $0.map { $0.copyToWork() } }
            .sink { [weak self] in
                guard let self = self else { return }
                
                cellViewModels.append(contentsOf: $0 )
                didUpdateBlocksTable.send()
            }
            .store(in: &subscriptions)
        
        removeBlock
            .sink { [weak self] cellViewModel in
                guard
                    let self = self,
                    let index = cellViewModels.firstIndex(where: { cellViewModel === $0 })
                else { return }
                
                cellViewModels.remove(at: index)
                didDeleteRows.send([IndexPath(row: index, section: 0)])
                
                if cellViewModels.count == 0 {
                    isWiggleMode.send(false)
                }
            }
            .store(in: &subscriptions)
        
        isWiggleMode
            .sink { [weak self] value in
                self?.cellViewModels.forEach { $0.isWiggleMode = value }
            }
            .store(in: &subscriptions)
        
        didBeginEditingBlocks
            .sink { [weak self] in
                guard let self = self else { return }
                guard cellViewModels.isEmpty == false else { return }
                
                isWiggleMode.send(true)
            }
            .store(in: &subscriptions)
    }
}
