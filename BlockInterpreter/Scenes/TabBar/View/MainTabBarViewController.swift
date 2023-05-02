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
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height), cornerRadius: height / 2)
        
        roundLayer.path = bezierPath.cgPath

        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 2
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.appWhite?.cgColor
        
        tabBar.tintColor = .appBlue
        tabBar.unselectedItemTintColor = .appBlack
    }
    
    private func setupSettingsBarButtonItem() {
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(handleSettingsBarButtonItem))
        
        settingsBarButtonItem.tintColor = .appWhite
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
}
