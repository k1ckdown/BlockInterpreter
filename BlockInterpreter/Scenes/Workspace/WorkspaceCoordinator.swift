//
//  WorkspaceCoordinator.swift
//  BlockInterpreter
//

import UIKit

final class WorkspaceCoordinator: BaseCoordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let workspaceViewModel = WorkspaceViewModel()
        let workspaceViewController = WorkspaceViewController(with: workspaceViewModel)
        
        workspaceViewModel.didGoToConsole = { [weak self] in
            self?.showConsoleScene()
        }
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(workspaceViewController, animated: true)
    }
}

private extension WorkspaceCoordinator {
    func showConsoleScene() {
        let consoleViewModel = ConsoleViewModel()
        let consoleViewController = ConsoleViewController(with: consoleViewModel)
        
        consoleViewController.navigationItem.title = "Console"
        let consoleNavController = UINavigationController(rootViewController: consoleViewController)

        if #available(iOS 15.0, *) {
            if let sheet = consoleNavController.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 30
                sheet.detents = [.medium(), .large()]
            }
        }
        
        navigationController.present(consoleNavController,
                                     animated: true)
    }
}
