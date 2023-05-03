//
//  WorkspaceViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
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
