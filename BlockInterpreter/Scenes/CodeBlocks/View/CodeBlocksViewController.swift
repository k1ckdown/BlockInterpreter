//
//  CodeBlocksViewController.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import UIKit

class CodeBlocksViewController: UIViewController {
    
    private let blocksTableView = UITableView(frame: .zero, style: .plain)
    
    private let viewModel: CodeBlocksViewModelType
    
    init(with viewModel: CodeBlocksViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        viewModel.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setup() {
        setupSuperView()
        setupBlocksTableView()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .systemIndigo
    }
    
    private func setupBlocksTableView() {
        view.addSubview(blocksTableView)
        
        blocksTableView.delegate = self
        blocksTableView.dataSource = self
        blocksTableView.separatorStyle = .none
        blocksTableView.backgroundColor = .clear
        blocksTableView.showsVerticalScrollIndicator = false
        blocksTableView.register(VariableBlockCell.self, forCellReuseIdentifier: VariableBlockCell.identifier)
        
        blocksTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview().inset(30)
        }
    }
}

extension CodeBlocksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Variables \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VariableBlockCell.identifier, for: indexPath) as? VariableBlockCell else {
            return VariableBlockCell()
        }
        
        cell.configure(with: viewModel.variableBlockCellViewModels[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        
        view.textLabel?.textColor = .appBlack
        view.contentView.backgroundColor = .appWhite
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        return view
    }
    
}

extension CodeBlocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
