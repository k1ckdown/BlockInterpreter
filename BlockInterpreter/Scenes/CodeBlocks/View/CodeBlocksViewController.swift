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
        view.backgroundColor = .appPurple
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
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitleForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.getSection(at: indexPath)
        
        switch section {
        case .variables:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VariableBlockCell.identifier, for: indexPath) as? VariableBlockCell else {
                return VariableBlockCell()
            }
            
            cell.variableNameTextField.delegate = self
            cell.variableValueTextField.delegate = self
            
            cell.variableNameTextField.tag = TextFieldType.variableName.tag
            cell.variableValueTextField.tag = TextFieldType.variableValue.tag
            
            cell.configure(with: viewModel.variableBlockCellViewModels[indexPath.row])
            return cell
            
        case .control:
            return VariableBlockCell()
        case .loops:
            return VariableBlockCell()
        case .arrays:
            return VariableBlockCell()
        case .functions:
            return VariableBlockCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = BlockHeaderView()
        headerView.headerTitle = viewModel.getTitleForHeaderInSection(section)
        
        return headerView
    }
    
}

extension CodeBlocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRowAt(indexPath)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


extension CodeBlocksViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
