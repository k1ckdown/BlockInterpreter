//
//  MainTabBarCoordinator.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class MainTabBarCoordinator: BaseCoordinator {
    
    private let hubViewModel: HubViewModel
    private let workspaceViewModel: WorkspaceViewModel
    
    private let mainTabBarController: UITabBarController
    private let algorithmRepository: AlgorithmRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    override init(navigationController: UINavigationController) {
        algorithmRepository = AlgorithmRepositoryImpl()
        hubViewModel = HubViewModel()
        
        workspaceViewModel = WorkspaceViewModel(
            interpreterManager: InterpreterManager(),
            algorithmRepository: algorithmRepository
        )
        
        mainTabBarController = MainTabBarViewController()
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        setupBindings()
        
        let viewControllers = TabFlow.allCases.map { getTab(with: $0) }
        
        navigationController.navigationBar.isHidden = true
        mainTabBarController.setViewControllers(viewControllers, animated: true)
        navigationController.setViewControllers([mainTabBarController], animated: true)
        
        selectTab(with: .workspace)
    }
    
    private func selectTab(with flow: TabFlow) {
        mainTabBarController.selectedIndex = flow.orderNumber
    }
    
    private func getTab(with tabType: TabFlow) -> UIViewController {
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
            
        case .hub:
            coordinator = HubCoordinator(navigationController: navController,
                                         hubViewModel: hubViewModel)
        }
        
        coordinate(to: coordinator)
        navController.tabBarItem = UITabBarItem(title: tabType.title,
                                                image: tabType.image,
                                                tag: tabType.orderNumber)
        
        return navController
    }
}

// MARK: - CodeBlocksCoordinatorDelegate

extension MainTabBarCoordinator: CodeBlocksCoordinatorDelegate {
    func goToWorkspace(blocks: [BlockCellViewModel]) {
        showWorkspace(blocks: blocks)
    }
}

// MARK: - Navigation

private extension MainTabBarCoordinator {
    func showWorkspace(blocks: [BlockCellViewModel]) {
        workspaceViewModel.addBlocks.send(blocks)
        mainTabBarController.tabBar(mainTabBarController.tabBar,
                                    didSelect: mainTabBarController.viewControllers?[TabFlow.workspace.orderNumber].tabBarItem ?? .init())
        selectTab(with: .workspace)
    }
}

private extension MainTabBarCoordinator {
    func setupBindings() {
        algorithmRepository.algorithms
            .sink { [weak self] in
                self?.hubViewModel.updateSavedAlgorithms.send($0)
            }
            .store(in: &subscriptions)
    }
}
