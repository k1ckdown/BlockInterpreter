//
//  Coordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootCoordinator: Coordinator? { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    func coordinate(to coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
    func removeChildCoordinators()
}
