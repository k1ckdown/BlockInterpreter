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
    private let codeBlocksDataSource: CodeBlocksDataSource
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: CodeBlocksViewModelType) {
        self.viewModel = viewModel
        codeBlocksDataSource = CodeBlocksDataSource(with: viewModel)
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
        blocksTableView.dataSource = codeBlocksDataSource
        blocksTableView.separatorStyle = .none
        blocksTableView.backgroundColor = .clear
        blocksTableView.contentInset.bottom = 50
        blocksTableView.showsVerticalScrollIndicator = false
        
        blocksTableView.register(FlowBlockCell.self, forCellReuseIdentifier: FlowBlockCell.reuseIdentifier)
        blocksTableView.register(ForLoopBlockCell.self, forCellReuseIdentifier: ForLoopBlockCell.reuseIdentifier)
        blocksTableView.register(ReturningBlockCell.self, forCellReuseIdentifier: ReturningBlockCell.reuseIdentifier)
        blocksTableView.register(WhileLoopBlockCell.self, forCellReuseIdentifier: WhileLoopBlockCell.reuseIdentifier)
        blocksTableView.register(FunctionBlockCell.self, forCellReuseIdentifier: FunctionBlockCell.reuseIdentifier)
        blocksTableView.register(OutputBlockCell.self, forCellReuseIdentifier: OutputBlockCell.reuseIdentifier)
        blocksTableView.register(VariableBlockCell.self, forCellReuseIdentifier: VariableBlockCell.reuseIdentifier)
        blocksTableView.register(ConditionBlockCell.self, forCellReuseIdentifier: ConditionBlockCell.reuseIdentifier)
        blocksTableView.register(ArrayMethodBlockCell.self, forCellReuseIdentifier: ArrayMethodBlockCell.reuseIdentifier)
        
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
