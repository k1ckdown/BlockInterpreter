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
        
        let viewControllers = TabType.allCases.map { createViewController(tabType: $0) }
        
        mainTabBarViewModel.didGoToSettingsScreen = { [weak self] in
            self?.showSettingsScene()
        }
        
        mainTabBarController.setViewControllers(viewControllers, animated: true)
        navigationController.setViewControllers([mainTabBarController], animated: true)
    }
    
    private func selectTab(with type: TabType) {
        mainTabBarController.selectedIndex = type.orderNumber
    }
    
    private func makeCodeBlocksViewController() -> UIViewController {
        let codeBlocksViewModel = CodeBlocksViewModel()
        let codeBlocksViewController = CodeBlocksViewController(with: codeBlocksViewModel)
        
        return codeBlocksViewController
    }
    
    private func makeWorkspaceViewController() -> UIViewController {
        let workspaceViewModel = WorkspaceViewModel()
        let workspaceViewController = WorkspaceViewController(with: workspaceViewModel)
        
        workspaceViewModel.didGoToConsoleTab = { [weak self] in
            self?.selectTab(with: .console)
        }
        
        return workspaceViewController
    }
    
    private func makeConsoleViewController() -> UIViewController {
        let consoleViewModel = ConsoleViewModel()
        let consoleViewController = ConsoleViewController(with: consoleViewModel)
        
        return consoleViewController
    }
    
    private func createViewController(tabType: TabType) -> UIViewController {
        let viewController: UIViewController
        
        switch tabType {
        case .codeblocks:
            viewController = makeCodeBlocksViewController()
            
        case .workspace:
            viewController = makeWorkspaceViewController()
            
        case .console:
            viewController = makeConsoleViewController()
        }
        
        viewController.tabBarItem = UITabBarItem(title: tabType.title,
                                                 image: tabType.imageSelected,
                                                 tag: tabType.orderNumber)
        return viewController
    }
}

private extension MainTabBarCoordinator {
    func showSettingsScene() {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        coordinate(to: settingsCoordinator)
    }
}
