//
//  ConsoleCoordinator.swift
//  BlockInterpreter
//

import UIKit

final class ConsoleCoordinator: BaseCoordinator {
    
    private let consoleViewModel: ConsoleViewModel
    
    init(navigationController: UINavigationController, outputText: String) {
        consoleViewModel = ConsoleViewModel(outputText: outputText)
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let consoleViewController = ConsoleViewController(with: consoleViewModel)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(consoleViewController, animated: true)
    }
}
