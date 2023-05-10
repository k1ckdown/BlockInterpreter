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
    private(set) var didGoToConsole = PassthroughSubject<Void, Never>()
    
    init() {
        bind()
    }
    
}

extension WorkspaceViewModel  {
    private func bind() {
        showConsole
            .sink { [weak self] in
                self?.didGoToConsole.send()
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
