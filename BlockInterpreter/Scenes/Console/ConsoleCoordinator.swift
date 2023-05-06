//
//  ConsoleCoordinator.swift
//  BlockInterpreter
//

import UIKit

final class ConsoleCoordinator: BaseCoordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let consoleViewModel = ConsoleViewModel()
        let consoleViewController = ConsoleViewController(with: consoleViewModel)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(consoleViewController, animated: true)
    }
}
