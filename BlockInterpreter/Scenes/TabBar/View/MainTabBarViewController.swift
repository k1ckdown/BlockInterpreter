//
//  MainTabBarViewController.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit
import WaveTab

class MainTabBarViewController: WaveTabBarController {
    
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
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .appPurple
        tabBar.unselectedItemTintColor = .appBlack
    }
    
}
