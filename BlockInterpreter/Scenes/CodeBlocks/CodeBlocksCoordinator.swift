//
//  CodeBlocksCoordinator.swift
//  BlockInterpreter
//

import UIKit
import Combine

protocol CodeBlocksCoordinatorDelegate: AnyObject {
    func goToWorkspace(blocks: [BlockCellViewModel])
}

final class CodeBlocksCoordinator: BaseCoordinator {
    
    weak var delegate: CodeBlocksCoordinatorDelegate?
    private var subscriptions = Set<AnyCancellable>()
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let codeBlocksViewModel = CodeBlocksViewModel()
        let codeBlocksViewController = CodeBlocksViewController(with: codeBlocksViewModel)
        
        codeBlocksViewModel.didGoToWorkspaceScreen
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.delegate?.goToWorkspace(blocks: $0) }
            .store(in: &subscriptions)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(codeBlocksViewController, animated: true)
    }
}
