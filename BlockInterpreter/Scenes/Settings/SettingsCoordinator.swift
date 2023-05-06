//
//  SettingsCoordinator.swift
//  BlockInterpreter
//

import UIKit

final class SettingsCoordinator: BaseCoordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController(with: settingsViewModel)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(settingsViewController, animated: true)
    }
}
