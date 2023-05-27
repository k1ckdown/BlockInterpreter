//
//  HubCoordinator.swift
//  BlockInterpreter
//

import UIKit
import Combine

protocol HubCoordinatorDelegate: AnyObject {
    func goToWorkspaceWithAlgorithm(_ algorithm: [IBlock])
}

final class HubCoordinator: BaseCoordinator {
    
    weak var delegate: HubCoordinatorDelegate?
    
    private let hubViewModel: HubViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, hubViewModel: HubViewModel) {
        self.hubViewModel = hubViewModel
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let hubViewController = HubViewController(with: hubViewModel)
        
        hubViewModel.didUpdateWorkspace
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.goToWorkspaceWithAlgorithm($0)
            }
            .store(in: &subscriptions)
        
        navigationController.pushViewController(hubViewController, animated: true)
    }
}
