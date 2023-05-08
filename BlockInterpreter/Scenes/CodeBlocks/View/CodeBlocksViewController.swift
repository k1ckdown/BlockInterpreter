//
//  CodeBlocksViewController.swift
//  BlockInterpreter
//

import UIKit

final class CodeBlocksViewController: UIViewController {
    
    private enum Constants {
            enum BlocksTableView {
                static let inset: CGFloat = 30
            }
    }
    
    private let blocksTableView = UITableView()
    private let optionsMenuToolbar = UIToolbar()
    
    private lazy var plusImageView: UIImageView = {
        let image = UIImage(systemName: "plus.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .orange
        
        return imageView
    }()

    private lazy var addBlockLabel: UILabel = {
        let label = UILabel()

        label.text = "To workspace"
        label.textColor = .appWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var addBlockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [plusImageView, addBlockLabel])

        stackView.spacing = 10
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private var viewModel: CodeBlocksViewModelType
    
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
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setup() {
        setupSuperView()
        setupBlocksTableView()
        setupOptionsMenuToolbar()
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
        blocksTableView.register(ConditionBlockCell.self, forCellReuseIdentifier: ConditionBlockCell.identifier)
        
        blocksTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(Constants.BlocksTableView.inset)
            make.bottom.equalToSuperview()
        }
    }
    
    
    private func setupOptionsMenuToolbar() {
        view.addSubview(optionsMenuToolbar)

        optionsMenuToolbar.isHidden = true
        optionsMenuToolbar.barStyle = .black
        optionsMenuToolbar.layer.cornerRadius = 10
        optionsMenuToolbar.layer.masksToBounds = true

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addBarButton = UIBarButtonItem(customView: addBlockStackView)
        optionsMenuToolbar.setItems([flexibleSpace, addBarButton, flexibleSpace], animated: true)

        optionsMenuToolbar.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - UITableViewDataSource

extension CodeBlocksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = BlockHeaderView()
        headerView.headerTitle = viewModel.getTitleForHeaderInSection(section)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.getSection(at: indexPath)
        let cellViewModel = viewModel.cellViewModels[section.rawValue][indexPath.row]
        
        switch section {
        case .variables:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: VariableBlockCell.identifier, for: indexPath) as? VariableBlockCell,
                let cellViewModel = cellViewModel as? VariableBlockCellViewModel
            else { return .init() }
            
            cell.variableNameTextField.delegate = self
            cell.variableValueTextField.delegate = self
            
            cell.variableNameTextField.tag = TextFieldType.variableName.tag
            cell.variableValueTextField.tag = TextFieldType.variableValue.tag
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .conditions:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: ConditionBlockCell.identifier, for: indexPath) as? ConditionBlockCell,
                let cellViewModel = cellViewModel as? ConditionBlockCellViewModel
            else { return .init() }
            
            cell.conditionTextField.delegate = self
            cell.conditionTextField.tag = TextFieldType.condition.tag
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .loops:
            return .init()
        case .arrays:
            return .init()
        case .functions:
            return .init()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension CodeBlocksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BlockCell else { return }
        viewModel.toggleSelectedIndexPath(indexPath)
        cell.select()
    }
}

// MARK: - UITextFieldDelegate


extension CodeBlocksViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - Building ViewModel

private extension CodeBlocksViewController {
    func bindViewModel() {
        viewModel.showOptionsMenu = { [weak self] in
            self?.optionsMenuToolbar.isHidden = false
            self?.tabBarController?.tabBar.isHidden = true
        }
        
        viewModel.hideOptionsMenu = { [weak self] in
            self?.optionsMenuToolbar.isHidden = true
            self?.tabBarController?.tabBar.isHidden = false
        }
    }
}
