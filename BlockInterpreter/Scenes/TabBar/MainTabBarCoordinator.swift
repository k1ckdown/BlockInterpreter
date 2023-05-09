//
//  MainTabBarCoordinator.swift
//  BlockInterpreter
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {
    
    private let mainTabBarController: UITabBarController
    
    override init(navigationController: UINavigationController) {
        mainTabBarController = MainTabBarViewController()
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewControllers = TabType.allCases.map { getTab(with: $0) }
        
        navigationController.navigationBar.isHidden = true
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
            if let coordinator = coordinator as? CodeBlocksCoordinator {
                coordinator.delegate = self
            }
            
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

// MARK: - Navigation

private extension MainTabBarCoordinator {
    func showWorkspace() {
        mainTabBarController.tabBar(mainTabBarController.tabBar,
                                    didSelect: mainTabBarController.viewControllers?[TabType.workspace.orderNumber].tabBarItem ?? .init())
        selectTab(with: .workspace)
    }
}

// MARK: - CodeBlocksCoordinatorDelegate

extension MainTabBarCoordinator: CodeBlocksCoordinatorDelegate {
    func goToWorkspace() {
        showWorkspace()
    }
}
