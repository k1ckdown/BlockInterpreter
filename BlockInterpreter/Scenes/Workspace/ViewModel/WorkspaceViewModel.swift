//
//  WorkspaceViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class WorkspaceViewModel: WorkspaceViewModelType {
    
    var showConsole = PassthroughSubject<Void, Never>()
    var moveBlock = PassthroughSubject<(IndexPath, IndexPath), Never>()
    
    var cellViewModels: [BlockCellViewModel]
    
    private var subscriptions = Set<AnyCancellable>()
    private(set) var didGoToConsole = PassthroughSubject<Void, Never>()
    
    init() {
        cellViewModels = [
                VariableBlockCellViewModel(variableType: nil, style: .work),
                ConditionBlockCellViewModel(conditionBlockType: .ifStatement, style: .work),
                VariableBlockCellViewModel(variableType: nil, style: .work),
                VariableBlockCellViewModel(variableType: nil, style: .work),
                VariableBlockCellViewModel(variableType: nil, style: .work)]
        bind()
    }
    
    private func didMoveBlock(from sourceIndex: Int, to destinationIndex: Int) {
        let cellViewModel = cellViewModels.remove(at: sourceIndex)
        cellViewModels.insert(cellViewModel, at: destinationIndex)
    }
}

extension WorkspaceViewModel  {
    private func bind() {
        showConsole
            .sink(receiveValue: { [weak self] in
                self?.didGoToConsole.send()
            })
            .store(in: &subscriptions)
        
        moveBlock
            .sink { [weak self] in
                self?.didMoveBlock(from: $0.0.row, to: $0.1.row)
            }
            .store(in: &subscriptions)
    }
}
