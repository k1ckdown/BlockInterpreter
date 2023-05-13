//
//  WorkspaceViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class WorkspaceViewModel: WorkspaceViewModelType {
    
    var showConsole = PassthroughSubject<Void, Never>()
    var didUpdateBlocksTable = PassthroughSubject<Void, Never>()
    var addBlocks = PassthroughSubject<[BlockCellViewModel], Never>()
    var moveBlock = PassthroughSubject<(IndexPath, IndexPath), Never>()
    
    var cellViewModels = CurrentValueSubject<[BlockCellViewModel], Never>([])
    
    private var subscriptions = Set<AnyCancellable>()
    private(set) var didGoToConsole = PassthroughSubject<String, Never>()
    
    private let interpreterManager: InterpreterManager
    
    init() {
        interpreterManager = .init()
        bind()
    }
    
}

extension WorkspaceViewModel  {
    private func getBlocks() -> [IBlock] {
        var blocks = [IBlock]()
        
        for (index, blockViewModel) in cellViewModels.value.enumerated() {
            
            if let variableBlockViewModel = blockViewModel as? VariableBlockCellViewModel {
                blocks.append(Variable(id: index,
                                       type: variableBlockViewModel.variableType ?? .int,
                                       name: variableBlockViewModel.variableName ?? "",
                                       value: variableBlockViewModel.variableValue ?? ""))
            }
            
            if let conditionBlockViewModel = blockViewModel as? ConditionBlockCellViewModel {
                blocks.append(Condition(id: index,
                                        type: conditionBlockViewModel.conditionType,
                                        value: conditionBlockViewModel.conditionText ?? ""))
            }
            
            if let flowBlockViewModel = blockViewModel as? FlowBlockCellViewModel {
                blocks.append(Flow(type: flowBlockViewModel.flowType))
            }
            
            if let outputBlockViewModel = blockViewModel as? OutputBlockCellViewModel {
                blocks.append(Output(id: index,
                                       value: outputBlockViewModel.text ?? ""))
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
                cellViewModels.value.insert(cellViewModels.value.remove(at: $0.0.row), at: $0.1.row)
            }
            .store(in: &subscriptions)
        
        addBlocks
            .map { $0.map { $0.copyToWork() } }
            .sink { [weak self] in
                self?.cellViewModels.value.append(contentsOf: $0 )
            }
            .store(in: &subscriptions)
        
        cellViewModels
            .sink { [weak self] _ in
                self?.didUpdateBlocksTable.send()
            }
            .store(in: &subscriptions)
    }
}
