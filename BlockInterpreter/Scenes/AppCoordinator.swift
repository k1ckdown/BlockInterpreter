//
//  AppCoordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        navigationController.overrideUserInterfaceStyle = .light
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        showMainTabBar()
    }
}

private extension AppCoordinator {
    func showMainTabBar() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        coordinate(to: mainTabBarCoordinator)
    }
}
