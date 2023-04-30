//
//  MainTabBarViewController.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private let viewModel: MainTabBarViewModelType
    
    init(with viewModel: MainTabBarViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    @objc
    private func handleSettingsBarButtonItem() {
        viewModel.showSettingsScreen()
    }
    
    private func setup() {
        setupTabBar()
        setupSettingsBarButtonItem()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .orange
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .blue
    }
    
    private func setupSettingsBarButtonItem() {
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(handleSettingsBarButtonItem))
        
        settingsBarButtonItem.tintColor = .orange
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    
}
