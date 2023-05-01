//
//  WorkspaceViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import Foundation

final class WorkspaceViewModel {
    var didGoToConsoleTab: (() -> Void)?
}

extension WorkspaceViewModel: WorkspaceViewModelType {
    func showConsole() {
        didGoToConsoleTab?()
    }
}
