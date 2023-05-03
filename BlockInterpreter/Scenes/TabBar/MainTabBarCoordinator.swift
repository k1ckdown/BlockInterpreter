//
//  MainTabBarCoordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {
    
    private let mainTabBarViewModel: MainTabBarViewModel
    private let mainTabBarController: UITabBarController
    
    override init(navigationController: UINavigationController) {
        mainTabBarViewModel = MainTabBarViewModel()
        mainTabBarController = MainTabBarViewController(with: mainTabBarViewModel)
        
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewControllers = TabType.allCases.map { getTab(with: $0) }
        
        mainTabBarController.setViewControllers(viewControllers, animated: true)
        navigationController.setViewControllers([mainTabBarController], animated: true)
    }
    
    private func selectTab(with type: TabType) {
        mainTabBarController.selectedIndex = type.orderNumber
    }
    
    private func getTab(with tabType: TabType) -> UIViewController {
        let navController = UINavigationController()
        let coordinator: Coordinator
        
        switch tabType {
        case .codeblocks:
            coordinator = CodeBlocksCoordinator(navigationController: navController)
            
        case .workspace:
            coordinator = WorkspaceCoordinator(navigationController: navController)
            
        case .settings:
            coordinator = SettingsCoordinator(navigationController: navController)
        }
        
        coordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(coordinator)
        coordinator.start()
        
        navController.tabBarItem = UITabBarItem(title: tabType.title,
                                                       image: tabType.image,
                                                       tag: tabType.orderNumber)
        
        return navController
    }
}
