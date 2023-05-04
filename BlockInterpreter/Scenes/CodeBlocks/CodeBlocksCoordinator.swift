//
//  CodeBlocksCoordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 02.05.2023.
//

import UIKit

final class CodeBlocksCoordinator: BaseCoordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let codeBlocksViewModel = CodeBlocksViewModel()
        let codeBlocksViewController = CodeBlocksViewController(with: codeBlocksViewModel)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(codeBlocksViewController, animated: true)
    }
}
