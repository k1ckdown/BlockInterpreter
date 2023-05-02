//
//  WorkspaceCoordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 02.05.2023.
//

import UIKit

protocol WorkspaceCoordinatorDelegate: AnyObject {
    func goToConsoleTab()
}

final class WorkspaceCoordinator: BaseCoordinator {
    
    weak var delegate: WorkspaceCoordinatorDelegate?

    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let workspaceViewModel = WorkspaceViewModel()
        let workspaceViewController = WorkspaceViewController(with: workspaceViewModel)
        
        workspaceViewModel.didGoToConsoleTab = { [weak self] in
            self?.showConsoleScene()
        }
        
        navigationController.pushViewController(workspaceViewController, animated: true)
    }
}

private extension WorkspaceCoordinator {
    func showConsoleScene() {
        delegate?.goToConsoleTab()
    }
}
