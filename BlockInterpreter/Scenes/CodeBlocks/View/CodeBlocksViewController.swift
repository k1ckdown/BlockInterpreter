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
        
            enum OptionsView {
                static let height: Double = 50
                static let width: Double = 220
            }
        
    }
    
    private let blocksTableView = UITableView()
    private let optionsView = OptionsView(configuration: .optionAddBlock)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideOptions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func hideOptions() {
        UIView.animate(withDuration: 0.5) {
            self.optionsView.frame.origin.y = self.view.frame.height + self.optionsView.frame.height
        }
        
    }
    
    private func showOptions() {
        UIView.animate(withDuration: 0.5) {
            self.optionsView.frame.origin.y = self.view.frame.height - self.optionsView.frame.height - 35
        }
    }
    
    private func hideTabBar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.height + (frame.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.frame = frame
        })
    }

    private func showTabBar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.height - (frame.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.frame = frame
        })
    }
    
    private func setupUI() {
        setupSuperView()
        setupBlocksTableView()
        setupOptionsView()
    }
    
    private func setupSuperView() {
        view.setGradientBackground()
    }
    
    private func setupBlocksTableView() {
        view.addSubview(blocksTableView)
        
        blocksTableView.delegate = self
        blocksTableView.dataSource = self
        blocksTableView.separatorStyle = .none
        blocksTableView.backgroundColor = .clear
        blocksTableView.contentInset.bottom = 50
        blocksTableView.showsVerticalScrollIndicator = false
        
        blocksTableView.register(FlowBlockCell.self, forCellReuseIdentifier: FlowBlockCell.identifier)
        blocksTableView.register(ForLoopBlockCell.self, forCellReuseIdentifier: ForLoopBlockCell.identifier)
        blocksTableView.register(WhileLoopBlockCell.self, forCellReuseIdentifier: WhileLoopBlockCell.identifier)
        blocksTableView.register(FunctionBlockCell.self, forCellReuseIdentifier: FunctionBlockCell.identifier)
        blocksTableView.register(OutputBlockCell.self, forCellReuseIdentifier: OutputBlockCell.identifier)
        blocksTableView.register(VariableBlockCell.self, forCellReuseIdentifier: VariableBlockCell.identifier)
        blocksTableView.register(ConditionBlockCell.self, forCellReuseIdentifier: ConditionBlockCell.identifier)
        
        blocksTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(Constants.BlocksTableView.inset)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupOptionsView() {
        view.addSubview(optionsView)
        
        optionsView.frame = CGRect(x: view.center.x -  Constants.OptionsView.width / 2,
                                   y: view.bounds.height,
                                   width:  Constants.OptionsView.width,
                                   height: Constants.OptionsView.height)
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
            
            cell.configure(with: cellViewModel)
            
            cell.textField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.outputValue = text
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .flow:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FlowBlockCell.identifier,
                    for: indexPath
                ) as? FlowBlockCell,
                let cellViewModel = cellViewModel as? FlowBlockCellViewModel
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
            
            cell.configure(with: cellViewModel)
            
            cell.variableNameTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.variableName = text
                }
                .store(in: &cell.subscriptions)
            
            cell.variableValueTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.variableValue = text
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .conditions:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ConditionBlockCell.identifier,
                    for: indexPath
                ) as? ConditionBlockCell,
                let cellViewModel = cellViewModel as? ConditionBlockCellViewModel
            else { return .init() }
            
            cell.configure(with: cellViewModel)
            
            cell.conditionTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.conditionText = text
                }
                .store(in: &cell.subscriptions)

            return cell
            
        case .loops:
            
            if cellViewModel.type.isEqualTo(.loop(.whileLoop)) {
                guard
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: WhileLoopBlockCell.identifier,
                        for: indexPath
                    ) as? WhileLoopBlockCell,
                    let cellViewModel = cellViewModel as? WhileLoopBlockCellViewModel
                else { return .init() }
                
                cell.configure(with: cellViewModel)
                
                cell.textField.textPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak cellViewModel] text in
                        guard let text = text else { return }
                        cellViewModel?.loopCondition = text
                    }
                    .store(in: &cell.subscriptions)
                
                return cell
            } else if cellViewModel.type.isEqualTo(.loop(.forLoop)) {
                guard
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: ForLoopBlockCell.identifier,
                        for: indexPath
                    ) as? ForLoopBlockCell,
                    let cellViewModel = cellViewModel as? ForLoopBlockCellViewModel
                else { return .init() }
                
                cell.configure(with: cellViewModel)
                
                cell.initValueTextField.textPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak cellViewModel] text in
                        guard let text = text else { return }
                        cellViewModel?.initValue = text
                    }
                    .store(in: &cell.subscriptions)
                
                cell.conditionValueTextField.textPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak cellViewModel] text in
                        guard let text = text else { return }
                        cellViewModel?.conditionValue = text
                    }
                    .store(in: &cell.subscriptions)
                
                cell.stepValueTextField.textPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak cellViewModel] text in
                        guard let text = text else { return }
                        cellViewModel?.stepValue = text
                    }
                    .store(in: &cell.subscriptions)
                
                return cell
            } else {
                return .init()
            }
            
        case .functions:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: FunctionBlockCell.identifier, for: indexPath) as? FunctionBlockCell,
                let cellViewModel = cellViewModel as? FunctionBlockCellViewModel
            else { return .init() }
            
            cell.configure(with: cellViewModel)
            
            cell.functionNameTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.functionName = text
                }
                .store(in: &subscriptions)
            
            cell.argumentsTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.argumentsString = text
                }
                .store(in: &subscriptions)
            
            return cell
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
          UIView.animate(withDuration: 0.4) {
              cell.transform = CGAffineTransform.identity
          }
    }
    
}

// MARK: - Reactive Behavior

private extension CodeBlocksViewController {
    func setupBindings() {
        optionsView.tapGesture.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.moveToWorkspace.send()
            }
            .store(in: &optionsView.subscriptions)
        
        viewModel.didUpdateMenuTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.optionsView.titleText = $0
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
            .sink { [weak self] isVisible in
                guard let self = self else { return }
                
                if isVisible {
                    hideTabBar()
                    showOptions()
                } else {
                    showTabBar()
                    hideOptions()
                }
            }
            .store(in: &subscriptions)
    }
}
