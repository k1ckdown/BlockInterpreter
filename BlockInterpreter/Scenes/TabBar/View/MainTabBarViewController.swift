//
//  MainTabBarViewController.swift
//  BlockInterpreter
//

import UIKit
import WaveTab

final class MainTabBarViewController: WaveTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .appMain
        tabBar.unselectedItemTintColor = .appWhite
        tabBar.overrideUserInterfaceStyle = .dark
    }
    
}
