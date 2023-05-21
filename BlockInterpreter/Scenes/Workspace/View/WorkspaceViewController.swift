//
//  WorkspaceViewController.swift
//  BlockInterpreter
//

import UIKit
import SnapKit
import Combine

final class WorkspaceViewController: UIViewController {
    
    private enum Constants {
        
            enum WorkBlocksTableView {
                static let rowHeight: CGFloat = 70
                static let insetTop: CGFloat = 10
                static let insetSide: CGFloat = 20
                static let insetBottom: CGFloat = 40
            }
        
            enum RunButton {
                static let size: CGFloat = 60
                static let cornerRadius: CGFloat = size / 2
                static let insetRight: CGFloat = 40
                static let insetBotton: CGFloat = 130
            }
        
            enum OptionsView {
                static let height: Double = 50
                static let width: Double = 220
            }
        
            enum IntroImageView {
                static let insetTop: CGFloat = 200
                static let multiplierWidth: CGFloat = 0.8
                static let multiplierHeight: CGFloat = 0.38
            }
            
            enum IntroLabel {
                static let insetTop: CGFloat = 22
            }
        
    }
    
    private let workBlocksTableView = UITableView()
    private let runButton = UIButton(type: .system)
    private let optionsView = OptionsView(configuration: .optionDeleteAllBlocks)
    
    private let workBlocksTapGesture = UITapGestureRecognizer()
    private let workBlocksLongPressGesture = UILongPressGestureRecognizer()
    
    private let introView = UIView()
    private let introImageView = UIImageView()
    private let introLabel = UILabel()
    
    private let viewModel: WorkspaceViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: WorkspaceViewModelType) {
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
    
    private func hideIntro() {
        introView.isHidden = true
        runButton.layer.opacity = 1
    }
    
    private func showIntro() {
        introView.isHidden = false
        runButton.layer.opacity = 0
    }
    
    private func hideRunButton() {
        UIView.transition(with: runButton, duration: 0.3) {
            self.runButton.layer.opacity = 0
        }
    }
    
    private func showRunButton() {
        UIView.transition(with: runButton, duration: 0.3) {
            self.runButton.layer.opacity = 1
        }
    }
    
    private func hideOptions() {
        UIView.animate(withDuration: 0.3) {
            self.optionsView.frame.origin.y = self.view.frame.height + self.optionsView.frame.height
        }
        
    }
    
    private func showOptions() {
        UIView.animate(withDuration: 0.3) {
            self.optionsView.frame.origin.y = self.view.frame.height - self.optionsView.frame.height - 35
        }
    }
    
    private func hideTabBar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.height + (frame.height)
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }

    private func showTabBar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.height - (frame.height)
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }
    
    private func enableEditingMode() {
        hideTabBar()
        hideRunButton()
        showOptions()
        
        workBlocksTableView.visibleCells.forEach {
            guard let cell = $0 as? BlockCell else { return }
            cell.isWiggleMode = true
        }
    }
    
    private func disableEditMode() {
        showTabBar()
        showRunButton()
        hideOptions()
        
        workBlocksTableView.visibleCells.forEach {
            guard let cell = $0 as? BlockCell else { return }
            cell.isWiggleMode = false
        }
    }
    
    private func animateCell(_ cell: UITableViewCell) {
        cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
          UIView.animate(withDuration: 0.4) {
              cell.transform = CGAffineTransform.identity
          }
    }
    
    private func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      workBlocksTableView.performBatchUpdates({
        workBlocksTableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
      }) { [weak self] _ in
          self?.viewModel.moveBlock.send((sourceIndexPath, destinationIndexPath))
      }
    }
    
    private func setupUI() {
        setupSuperView()
        setupWorkBlocksTableView()
        setupRunButton()
        setupOptionsView()
        setupIntroView()
        setupIntroImageView()
        setupIntroLabel()
    }
    
    private func setupSuperView() {
        view.setGradientBackground()
    }
    
    private func setupWorkBlocksTableView() {
        view.addSubview(workBlocksTableView)
        
        workBlocksTableView.dataSource = self
        workBlocksTableView.dragDelegate = self
        workBlocksTableView.dropDelegate = self
        workBlocksTableView.separatorStyle = .none
        workBlocksTableView.backgroundColor = .clear
        workBlocksTableView.showsVerticalScrollIndicator = false
        workBlocksTableView.showsHorizontalScrollIndicator = false
        workBlocksTableView.rowHeight = Constants.WorkBlocksTableView.rowHeight
        workBlocksTableView.contentInset.top = Constants.WorkBlocksTableView.insetTop
        workBlocksTableView.contentInset.bottom = Constants.WorkBlocksTableView.insetBottom
        
        workBlocksTableView.register(FunctionBlockCell.self, forCellReuseIdentifier: FunctionBlockCell.identifier)
        workBlocksTableView.register(FlowBlockCell.self, forCellReuseIdentifier: FlowBlockCell.identifier)
        workBlocksTableView.register(OutputBlockCell.self, forCellReuseIdentifier: OutputBlockCell.identifier)
        workBlocksTableView.register(ForLoopBlockCell.self, forCellReuseIdentifier: ForLoopBlockCell.identifier)
        workBlocksTableView.register(WhileLoopBlockCell.self, forCellReuseIdentifier: WhileLoopBlockCell.identifier)
        workBlocksTableView.register(VariableBlockCell.self, forCellReuseIdentifier: VariableBlockCell.identifier)
        workBlocksTableView.register(ConditionBlockCell.self, forCellReuseIdentifier: ConditionBlockCell.identifier)
        
        workBlocksTableView.addGestureRecognizer(workBlocksTapGesture)
        workBlocksTableView.addGestureRecognizer(workBlocksLongPressGesture)
        
        workBlocksTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(Constants.WorkBlocksTableView.insetSide)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupRunButton() {
        view.addSubview(runButton)
        
        runButton.backgroundColor = .appGray
        runButton.tintColor = .systemGreen
        runButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        runButton.layer.cornerRadius = Constants.RunButton.cornerRadius
        
        runButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.RunButton.size)
            make.right.equalToSuperview().inset(Constants.RunButton.insetRight)
            make.bottom.equalToSuperview().inset(Constants.RunButton.insetBotton)
        }
    }
    
    private func setupOptionsView() {
        view.addSubview(optionsView)
        
        
        optionsView.titleText = viewModel.optionTitle
        let width = Constants.OptionsView.width
        optionsView.frame = CGRect(x: view.center.x - width / 2,
                                   y: view.bounds.height,
                                   width: width,
                                   height: Constants.OptionsView.height)
    }
    
    private func setupIntroView() {
        view.addSubview(introView)
    
        introView.backgroundColor = .clear
        
        introView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupIntroImageView() {
        introView.addSubview(introImageView)
        
        introImageView.image = UIImage(named: "intro-blocks")
        introImageView.contentMode = .scaleToFill
        
        introImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(Constants.IntroImageView.multiplierHeight)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Constants.IntroImageView.multiplierWidth)
            make.top.equalToSuperview().offset(Constants.IntroImageView.insetTop)
        }
    }
    
    private func setupIntroLabel() {
        introView.addSubview(introLabel)
        
        introLabel.textColor = .appWhite
        introLabel.text = viewModel.introTitle
        introLabel.font = .workspaceIntroTitle
        
        introLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(introImageView.snp.bottom).offset(Constants.IntroLabel.insetTop)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension WorkspaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModels.value[indexPath.row]
        
        switch cellViewModel.type {
        case .output:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: OutputBlockCell.identifier,
                    for: indexPath
                ) as? OutputBlockCell,
                let cellViewModel = cellViewModel as? OutputBlockCellViewModel
            else { return .init() }
            
            cell.textField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.outputValue = text
                }
                .store(in: &cell.subscriptions)
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .flow:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: FlowBlockCell.identifier, for: indexPath) as? FlowBlockCell,
                let cellViewModel = cellViewModel as? FlowBlockCellViewModel
            else { return .init() }
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .variable:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: VariableBlockCell.identifier,
                    for: indexPath
                ) as? VariableBlockCell,
                let cellViewModel = cellViewModel as? VariableBlockCellViewModel
            else { return .init() }
            
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .condition:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ConditionBlockCell.identifier,
                    for: indexPath
                ) as? ConditionBlockCell,
                let cellViewModel = cellViewModel as? ConditionBlockCellViewModel
            else { return .init() }
            
            cell.conditionTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.conditionText = text
                }
                .store(in: &cell.subscriptions)
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .loop(.whileLoop):
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: WhileLoopBlockCell.identifier, for: indexPath) as? WhileLoopBlockCell,
                let cellViewModel = cellViewModel as? WhileLoopBlockCellViewModel
            else { return .init() }
            
            cell.textField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.loopCondition = text
                }
                .store(in: &cell.subscriptions)
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .loop(.forLoop):
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: ForLoopBlockCell.identifier, for: indexPath) as? ForLoopBlockCell,
                let cellViewModel = cellViewModel as? ForLoopBlockCellViewModel
            else { return .init() }
            
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .function:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: FunctionBlockCell.identifier, for: indexPath) as? FunctionBlockCell,
                let cellViewModel = cellViewModel as? FunctionBlockCellViewModel
            else { return .init() }
                        
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
}

// MARK: - UITableViewDragDelegate

extension WorkspaceViewController: UITableViewDragDelegate {
    
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
      let item = UIDragItem(itemProvider: NSItemProvider())
      item.localObject = indexPath
      viewModel.isWiggleMode.send(true)
      
      return [item]
  }

  func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
      let preview = UIDragPreviewParameters()
      
      preview.backgroundColor = .clear
      if #available(iOS 14.0, *) {
          preview.shadowPath = UIBezierPath(rect: .zero)
      }
      
      return preview
  }

}

// MARK: - UITableViewDropDelegate

extension WorkspaceViewController: UITableViewDropDelegate {

  func tableView(
    _ tableView: UITableView,
    dropSessionDidUpdate session: UIDropSession,
    withDestinationIndexPath destinationIndexPath: IndexPath?
  ) -> UITableViewDropProposal {
      guard
          let item = session.items.first,
          let fromIndexPath = item.localObject as? IndexPath,
          let toIndexPath = destinationIndexPath
      else { return UITableViewDropProposal(operation: .forbidden) }
        
      if fromIndexPath.section == toIndexPath.section {
        return .init(operation: .move, intent: .automatic)
      }
      
      return UITableViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
  }

  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
      guard
        let item = coordinator.session.items.first,
        let sourceIndexPath = item.localObject as? IndexPath,
        let destinationIndexPath = coordinator.destinationIndexPath
      else { return }

      switch coordinator.proposal.intent {
        case .insertAtDestinationIndexPath:
          move(from: sourceIndexPath, to: destinationIndexPath)
          coordinator.drop(item, toRowAt: destinationIndexPath)

        case .insertIntoDestinationIndexPath:
          coordinator.drop(item, toRowAt: sourceIndexPath)
        default: break
      }
  }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let preview = UIDragPreviewParameters()
        
        preview.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            preview.shadowPath = UIBezierPath(rect: .zero)
        }
        
        return preview
    }
    
}

// MARK: - Reactive Behavior

private extension WorkspaceViewController {
    
    func setupBindings() {
        runButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.showConsole.send()
            }
            .store(in: &subscriptions)
        
        workBlocksTapGesture.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.isWiggleMode.send(false)
            }
            .store(in: &subscriptions)
        
        workBlocksLongPressGesture.longPressPublisher
            .sink { [weak self] _ in
                self?.viewModel.didBeginEditingBlocks.send()
            }
            .store(in: &subscriptions)
        
        optionsView.tapGesture.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.deleteAllBlocks.send()
            }
            .store(in: &optionsView.subscriptions)
        
        viewModel.isWiggleMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                $0 == true ? enableEditingMode() : disableEditMode()
            }
            .store(in: &subscriptions)
        
        viewModel.isIntroHidden
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                $0 == true ? hideIntro() : showIntro()
            }
            .store(in: &subscriptions)
        
        viewModel.didUpdateBlocksTable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.workBlocksTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.didDeleteRows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.workBlocksTableView.deleteRows(at: $0, with: .fade)
            }
            .store(in: &subscriptions)
    }
    
}
