//
//  WorkspaceViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class WorkspaceViewModel {
    
    var showConsole = PassthroughSubject<Void, Never>()

    private var subscriptions = Set<AnyCancellable>()
    private(set) var didGoToConsole = PassthroughSubject<Void, Never>()
    
    private(set) var cellViewModels: [BlockCellViewModel]
    
    init() {
        cellViewModels = [
                VariableBlockCellViewModel(variableType: nil, style: .work),
                ConditionBlockCellViewModel(conditionBlockType: .ifStatement, style: .work),
                VariableBlockCellViewModel(variableType: nil, style: .work),
                VariableBlockCellViewModel(variableType: nil, style: .work),
                VariableBlockCellViewModel(variableType: nil, style: .work)]
        bind()
    }
    
    func moveBlock(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let cellViewModel = cellViewModels.remove(at: sourceIndexPath.row)
        cellViewModels.insert(cellViewModel, at: destinationIndexPath.row)
    }
}

extension WorkspaceViewModel  {
    private func bind() {
        showConsole
            .sink(receiveValue: { [weak self] in
                self?.didGoToConsole.send()
            })
            .store(in: &subscriptions)
    }
}
