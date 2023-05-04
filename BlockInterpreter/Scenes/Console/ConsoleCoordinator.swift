//
//  ConsoleCoordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 02.05.2023.
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
