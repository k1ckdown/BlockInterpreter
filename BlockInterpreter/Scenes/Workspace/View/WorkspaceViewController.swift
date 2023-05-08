//
//  WorkspaceViewController.swift
//  BlockInterpreter
//

import UIKit
import SnapKit

final class WorkspaceViewController: UIViewController {
    
    private enum Constants {
        enum RunButton {
            static let size: CGFloat = 60
            static let cornerRadius: CGFloat = size / 2
            static let insetRight: CGFloat = 40
            static let insetBotton: CGFloat = 130
        }
    }
    
    private let codeTableView = UITableView()
    private let runButton = UIButton(type: .system)
    
    private lazy var backdrop: UIView = {
        let backdrop = UIView()
        backdrop.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        backdrop.isHidden = true
        return backdrop
    }()
    
    private let viewModel: WorkspaceViewModelType
    
    init(with viewModel: WorkspaceViewModelType) {
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
    private func handleRunButton() {
        viewModel.showConsole()
    }
    
    private func setup() {
        setupSuperView()
        setupCodeTableView()
        setupRunButton()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .systemBlue
    }
    
    private func setupCodeTableView() {
        view.addSubview(codeTableView)
        
        codeTableView.backgroundColor = .systemBlue
        codeTableView.register(VariableBlockCell.self, forCellReuseIdentifier: VariableBlockCell.identifier)
        
        codeTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupRunButton() {
        view.addSubview(runButton)
        
        runButton.backgroundColor = .appBlack
        runButton.tintColor = .systemGreen
        runButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        runButton.layer.cornerRadius = Constants.RunButton.cornerRadius
        runButton.addTarget(self, action: #selector(handleRunButton), for: .touchUpInside)
        
        runButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.RunButton.size)
            make.right.equalToSuperview().inset(Constants.RunButton.insetRight)
            make.bottom.equalToSuperview().inset(Constants.RunButton.insetBotton)
        }
    }
    
}
