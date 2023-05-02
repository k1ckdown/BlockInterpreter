//
//  SettingsViewController.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 01.05.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let viewModel: SettingsViewModelType
    
    init(with viewModel: SettingsViewModelType) {
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
    
    private func setup() {
        setupSuperView()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .appBlack
    }

}