//
//  ConsoleViewController.swift
//  BlockInterpreter
//

import UIKit

final class ConsoleViewController: UIViewController {
    
    private let viewModel: ConsoleViewModelType
    
    init(with viewModel: ConsoleViewModelType) {
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
        view.backgroundColor = .systemGreen
    }

}
