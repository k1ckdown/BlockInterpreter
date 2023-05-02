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
        
        mainTabBarViewModel.didGoToSettingsScreen = { [weak self] in
            self?.showSettingsScene()
        }
        
        mainTabBarController.setViewControllers(viewControllers, animated: true)
        navigationController.setViewControllers([mainTabBarController], animated: true)
    }
    
    private func selectTab(with type: TabType) {
        mainTabBarController.selectedIndex = type.orderNumber
    }
    
    private func getTab(with tabType: TabType) -> UIViewController {
        let navigationController = UINavigationController()
        
        switch tabType {
        case .codeblocks:
            let codeBlocksCoordinator = CodeBlocksCoordinator(navigationController: navigationController)
            coordinate(to: codeBlocksCoordinator)
            
        case .workspace:
            let workspaceCoordinator = WorkspaceCoordinator(navigationController: navigationController)
            workspaceCoordinator.delegate = self
            coordinate(to: workspaceCoordinator)
            
        case .console:
            let consoleCoordinator = ConsoleCoordinator(navigationController: navigationController)
            coordinate(to: consoleCoordinator)
            
        }
        
        navigationController.tabBarItem = UITabBarItem(title: tabType.title,
                                                       image: tabType.image,
                                                       tag: tabType.orderNumber)
        
        return navigationController
    }
}

private extension MainTabBarCoordinator {
    func showSettingsScene() {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        coordinate(to: settingsCoordinator)
    }
}

extension MainTabBarCoordinator: WorkspaceCoordinatorDelegate {
    func goToConsoleTab() {
        selectTab(with: .console)
    }
}
