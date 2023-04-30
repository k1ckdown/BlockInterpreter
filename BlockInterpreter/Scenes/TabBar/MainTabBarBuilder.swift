//
//  MainTabBarBuilder.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit

final class MainTabBarBuilder {
    class func buildViewControllers() -> [UIViewController] {
        
        let codeBlocksViewModel = CodeBlocksViewModel()
        let codeBlocksViewController = CodeBlocksViewController(with: codeBlocksViewModel)
        setupViewController(viewController: codeBlocksViewController, title: "CodeBlocks", imageName: "")
        
        let workspaceViewModel = WorkspaceViewModel()
        let workspaceViewController = WorkspaceViewController(with: workspaceViewModel)
        setupViewController(viewController: workspaceViewController, title: "Workspace", imageName: "")
        
        let consoleViewModel = ConsoleViewModel()
        let consoleViewController = ConsoleViewController(with: consoleViewModel)
        setupViewController(viewController: consoleViewController, title: "Console", imageName: "")
        
        return [
            codeBlocksViewController,
            workspaceViewController,
            consoleViewController
        ]
    }
    
    class func setupViewController(viewController: UIViewController, title: String, imageName: String) {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: imageName)
    }
}

