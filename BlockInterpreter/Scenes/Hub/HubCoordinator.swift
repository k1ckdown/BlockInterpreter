//
//  HubCoordinator.swift
//  BlockInterpreter
//

import UIKit

final class HubCoordinator: BaseCoordinator {
    
    private let hubViewModel: HubViewModel
    
    init(navigationController: UINavigationController, hubViewModel: HubViewModel) {
        self.hubViewModel = hubViewModel
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let hubViewController = HubViewController(with: hubViewModel)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(hubViewController, animated: true)
    }
}
