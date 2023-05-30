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
            .sink { [weak self] in self?.showConsoleScene(outputText: $0) }
            .store(in: &subscriptions)
        
        navigationController.pushViewController(workspaceViewController, animated: true)
    }
}

// MARK: - Navigation

private extension WorkspaceCoordinator {
    func showConsoleScene(outputText: String) {
        let consoleViewModel = ConsoleViewModel(outputText: outputText)
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
        
        navigationController.present(consoleNavController, animated: true)
    }
}
