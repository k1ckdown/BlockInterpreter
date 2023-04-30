//
//  MainTabBarCoordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let mainTabBarViewModel = MainTabBarViewModel()
        let mainTabBarController = MainTabBarViewController(with: mainTabBarViewModel)
        
        mainTabBarViewModel.didGoToSettingsScreen = { [weak self] in
            self?.showSettingsScene()
        }
        
        mainTabBarController.setViewControllers(MainTabBarBuilder.buildViewControllers(), animated: true)
        navigationController.setViewControllers([mainTabBarController], animated: true)
    }
}

private extension MainTabBarCoordinator {
    func showSettingsScene() {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        coordinate(to: settingsCoordinator)
    }
}
