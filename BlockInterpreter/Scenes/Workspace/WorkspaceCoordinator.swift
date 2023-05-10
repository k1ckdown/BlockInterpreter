//
//  WorkspaceCoordinator.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class WorkspaceCoordinator: BaseCoordinator {
    
    let workspaceViewModel: WorkspaceViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, workspaceViewModel: WorkspaceViewModel) {
        self.workspaceViewModel = workspaceViewModel
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let workspaceViewController = WorkspaceViewController(with: workspaceViewModel)
        
        workspaceViewModel.didGoToConsole
            .sink { [weak self] in self?.showConsoleScene() }
            .store(in: &subscriptions)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(workspaceViewController, animated: true)
    }
}

// MARK: - Navigation

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
