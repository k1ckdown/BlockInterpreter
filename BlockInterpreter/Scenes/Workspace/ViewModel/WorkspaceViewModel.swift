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
    
    init() {
        bind()
    }
}

extension WorkspaceViewModel  {
    private func bind() {
        showConsole
            .sink(receiveValue: { [weak self] in self?.didGoToConsole.send()})
            .store(in: &subscriptions)
    }
}
