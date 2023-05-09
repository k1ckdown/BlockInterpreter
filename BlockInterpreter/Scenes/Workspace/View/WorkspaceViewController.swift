//
//  WorkspaceViewController.swift
//  BlockInterpreter
//

import UIKit
import SnapKit
import Combine

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
    
    private let viewModel: WorkspaceViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: WorkspaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        setupSuperView()
        setupCodeTableView()
        setupRunButton()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .systemBlue
    }
    
    private func setupCodeTableView() {
        view.addSubview(codeTableView)
        
        codeTableView.delegate = self
        codeTableView.dataSource = self
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
        
        runButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.RunButton.size)
            make.right.equalToSuperview().inset(Constants.RunButton.insetRight)
            make.bottom.equalToSuperview().inset(Constants.RunButton.insetBotton)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension WorkspaceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .darkGray
        cell.textLabel?.text = "Cell in row\(indexPath.row)"
        
        codeTableView.insertSubview(.init(), at: 3)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    }
    
}

// MARK: - UITableViewDelegate

extension WorkspaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected work cell")
    }
}


// MARK: - Reactive Behavior

private extension WorkspaceViewController {
    func setupBindings() {
        runButton.tapPublisher
            .sink(receiveValue: { [weak self] in self?.viewModel.showConsole.send()})
            .store(in: &subscriptions)
    }
}
