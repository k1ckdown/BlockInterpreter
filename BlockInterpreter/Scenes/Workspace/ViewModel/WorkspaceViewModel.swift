//
//  WorkspaceViewModel.swift
//  BlockInterpreter
//

import Foundation

final class WorkspaceViewModel {
    var didGoToConsole: (() -> Void)?
}

extension WorkspaceViewModel: WorkspaceViewModelType {
    func showConsole() {
        didGoToConsole?()
    }
}
