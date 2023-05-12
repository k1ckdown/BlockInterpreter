//
//  MainTabBarCoordinator.swift
//  BlockInterpreter
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {
    
    private let workspaceViewModel: WorkspaceViewModel
    private let mainTabBarController: UITabBarController
    
    override init(navigationController: UINavigationController) {
        workspaceViewModel = WorkspaceViewModel()
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
            coordinator = WorkspaceCoordinator(navigationController: navController,
                                               workspaceViewModel: workspaceViewModel)
            
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
    func showWorkspace(blocks: [BlockCellViewModel]) {
        workspaceViewModel.addBlocks.send(blocks)
        mainTabBarController.tabBar(mainTabBarController.tabBar,
                                    didSelect: mainTabBarController.viewControllers?[TabType.workspace.orderNumber].tabBarItem ?? .init())
        selectTab(with: .workspace)
    }
}

// MARK: - CodeBlocksCoordinatorDelegate

extension MainTabBarCoordinator: CodeBlocksCoordinatorDelegate {
    func goToWorkspace(blocks: [BlockCellViewModel]) {
        showWorkspace(blocks: blocks)
    }
}
