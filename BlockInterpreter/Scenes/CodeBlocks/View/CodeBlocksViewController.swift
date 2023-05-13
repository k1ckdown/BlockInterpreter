//
//  CodeBlocksViewController.swift
//  BlockInterpreter
//

import UIKit
import Combine
import CombineCocoa

final class CodeBlocksViewController: UIViewController {
    
    private enum Constants {
            enum BlocksTableView {
                static let inset: CGFloat = 30
            }
        
            enum OptionsMenuToolbar {
                static let height: Double = 50
                static let cornerRadius: CGFloat = 10
                static let multiplierWidth: Double = 0.6
            }
    }
    
    private let blocksTableView = UITableView()
    private let optionsMenuToolbar = UIToolbar()
    private let addBlocksTapGesture = UITapGestureRecognizer()
    
    private lazy var plusImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.tintColor = .appMain
        imageView.image = UIImage(systemName: "plus.circle.fill")
        
        return imageView
    }()

    private lazy var addBlockLabel: UILabel = {
        let label = UILabel()

        label.text = "To workspace"
        label.textColor = .appWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()

    private lazy var addBlockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [plusImageView, addBlockLabel])

        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.addGestureRecognizer(addBlocksTapGesture)
        
        return stackView
    }()
    
    private let viewModel: CodeBlocksViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: CodeBlocksViewModelType) {
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
        viewModel.viewDidLoad.send()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupUI() {
        setupSuperView()
        setupBlocksTableView()
        setupOptionsMenuToolbar()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .appBackground
    }
    
    private func setupBlocksTableView() {
        view.addSubview(blocksTableView)
        
        blocksTableView.delegate = self
        blocksTableView.dataSource = self
        blocksTableView.separatorStyle = .none
        blocksTableView.backgroundColor = .clear
        blocksTableView.showsVerticalScrollIndicator = false
        
        blocksTableView.register(FlowBlockCell.self, forCellReuseIdentifier: FlowBlockCell.identifier)
        blocksTableView.register(OutputBlockCell.self, forCellReuseIdentifier: OutputBlockCell.identifier)
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
        optionsMenuToolbar.layer.masksToBounds = true
        optionsMenuToolbar.layer.cornerRadius = Constants.OptionsMenuToolbar.cornerRadius
        
        let width = view.bounds.width * Constants.OptionsMenuToolbar.multiplierWidth
        optionsMenuToolbar.frame = CGRect(x: view.center.x - width / 2,
                                          y: view.bounds.height * 0.85,
                                          width: width,
                                          height: Constants.OptionsMenuToolbar.height)

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addBarButton = UIBarButtonItem(customView: addBlockStackView)
        optionsMenuToolbar.items = [flexibleSpace, addBarButton, flexibleSpace]
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.getSection(at: indexPath)
        let cellViewModel = viewModel.cellViewModels[section.rawValue][indexPath.row]
        
        switch section {
        case .output:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: OutputBlockCell.identifier,
                    for: indexPath
                ) as? OutputBlockCell,
                let cellViewModel = cellViewModel as? OutputBlockCellViewModel
            else { return .init() }
            
            cell.outputTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] in
                    cellViewModel?.outputText = $0
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .flow:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FlowBlockCell.identifier,
                    for: indexPath
                ) as? FlowBlockCell,
                let cellViewModel = cellViewModel as? FlowCellViewModel
            else { return .init() }

            cell.configure(with: cellViewModel)
            return cell
            
        case .variables:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: VariableBlockCell.identifier,
                    for: indexPath
                ) as? VariableBlockCell,
                let cellViewModel = cellViewModel as? VariableBlockCellViewModel
            else { return .init() }
            
            cell.variableNameTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] in
                    cellViewModel?.variableName = $0
                }
                .store(in: &cell.subscriptions)
            
            cell.variableValueTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] in
                    cellViewModel?.variableValue = $0
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .conditions:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ConditionBlockCell.identifier,
                    for: indexPath
                ) as? ConditionBlockCell,
                let cellViewModel = cellViewModel as? ConditionBlockCellViewModel
            else { return .init() }
            
            cell.conditionTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] in
                    cellViewModel?.conditionText = $0
                }
                .store(in: &cell.subscriptions)

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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = BlockHeaderView()
        headerView.headerTitle = viewModel.getTitleForHeaderInSection(section)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BlockCell else { return }
        
        viewModel.toggleSelectedIndexPath.send(indexPath)
        cell.select()
    }
    
}

// MARK: - Reactive Behavior

private extension CodeBlocksViewController {
    func setupBindings() {
        addBlocksTapGesture.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.moveToWorkspace.send()
            }
            .store(in: &subscriptions)
        
        viewModel.didUpdateTable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.blocksTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.isOptionsMenuVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.optionsMenuToolbar.isHidden = !$0
                self?.tabBarController?.tabBar.isHidden = $0
            }
            .store(in: &subscriptions)
    }
}
