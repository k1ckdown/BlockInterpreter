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
    private let optionsView = OptionsView(configuration: .optionDeleteAllBlocks)
    
    private let workBlocksTapGesture = UITapGestureRecognizer()
    private let workBlocksLongPressGesture = UILongPressGestureRecognizer()
    
    let runBarButton = UIBarButtonItem(barButtonSystemItem: .play, target: nil, action: nil)
    let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
    
    private let introView = UIView()
    private let introImageView = UIImageView()
    private let introLabel = UILabel()
    
    private let viewModel: WorkspaceViewModelType
    private let workspaceDataSource: WorkspaceDataSource
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: WorkspaceViewModelType) {
        self.viewModel = viewModel
        workspaceDataSource = WorkspaceDataSource(with: viewModel)
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
        navigationController?.navigationBar.isHidden = false
    }
    
    private func showIntro() {
        introView.isHidden = false
        navigationController?.navigationBar.isHidden = true
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
        showOptions()
        navigationController?.navigationBar.isHidden = true
        
        workBlocksTableView.visibleCells.forEach {
            guard let cell = $0 as? BlockCell else { return }
            cell.isWiggleMode = true
        }
    }
    
    private func disableEditMode() {
        showTabBar()
        hideOptions()
        navigationController?.navigationBar.isHidden = false
        
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
    
    private func presentAlertToSaveAlgorithm() {
        let alertController = UIAlertController(title: LocalizedStrings.saveAlgorithm(), message: "", preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = .dark
        
        var saveTextField: UITextField?
        
        alertController.addTextField() { textField in
            saveTextField = textField
            textField.placeholder = LocalizedStrings.enterNameFile()
        }
        
        let okAction = UIAlertAction(title: LocalizedStrings.ok(), style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            viewModel.saveAlgorithm.send((saveTextField?.text, workBlocksTableView.takeScreenshot()?.pngData()))
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    private func setupUI() {
        setupSuperView()
        setupWorkBlocksTableView()
        setupOptionsView()
        setupIntroView()
        setupIntroImageView()
        setupIntroLabel()
        setupRunBarButton()
        setupSaveBarButton()
    }
    
    private func setupSuperView() {
        view.setGradientBackground()
    }
    
    private func setupWorkBlocksTableView() {
        view.addSubview(workBlocksTableView)
        
        workBlocksTableView.dragDelegate = self
        workBlocksTableView.dropDelegate = self
        workBlocksTableView.dataSource = workspaceDataSource
        workBlocksTableView.separatorStyle = .none
        workBlocksTableView.backgroundColor = .clear
        workBlocksTableView.showsVerticalScrollIndicator = false
        workBlocksTableView.showsHorizontalScrollIndicator = false
        workBlocksTableView.rowHeight = Constants.WorkBlocksTableView.rowHeight
        workBlocksTableView.contentInset.top = Constants.WorkBlocksTableView.insetTop
        workBlocksTableView.contentInset.bottom = Constants.WorkBlocksTableView.insetBottom
        
        workBlocksTableView.register(FlowBlockCell.self, forCellReuseIdentifier: FlowBlockCell.reuseIdentifier)
        workBlocksTableView.register(OutputBlockCell.self, forCellReuseIdentifier: OutputBlockCell.reuseIdentifier)
        workBlocksTableView.register(ForLoopBlockCell.self, forCellReuseIdentifier: ForLoopBlockCell.reuseIdentifier)
        workBlocksTableView.register(FunctionBlockCell.self, forCellReuseIdentifier: FunctionBlockCell.reuseIdentifier)
        workBlocksTableView.register(VariableBlockCell.self, forCellReuseIdentifier: VariableBlockCell.reuseIdentifier)
        workBlocksTableView.register(ConditionBlockCell.self, forCellReuseIdentifier: ConditionBlockCell.reuseIdentifier)
        workBlocksTableView.register(WhileLoopBlockCell.self, forCellReuseIdentifier: WhileLoopBlockCell.reuseIdentifier)
        workBlocksTableView.register(ArrayMethodBlockCell.self, forCellReuseIdentifier: ArrayMethodBlockCell.reuseIdentifier)
        workBlocksTableView.register(ReturningBlockCell.self, forCellReuseIdentifier: ReturningBlockCell.reuseIdentifier)
        
        workBlocksTableView.addGestureRecognizer(workBlocksTapGesture)
        workBlocksTableView.addGestureRecognizer(workBlocksLongPressGesture)
        
        workBlocksTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(Constants.WorkBlocksTableView.insetSide)
            make.bottom.equalToSuperview()
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
    
    private func setupRunBarButton() {
        runBarButton.tintColor = .appGreen
        navigationItem.rightBarButtonItem = runBarButton
    }
    
    private func setupSaveBarButton() {
        saveBarButton.tintColor = .appMain
        navigationItem.leftBarButtonItem = saveBarButton
    }
    
}

// MARK: - UITableViewDataSource



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
        runBarButton.tapPublisher
            .sink { [weak self] in
            self?.viewModel.showConsole.send()
        }
        .store(in: &subscriptions)
        
        saveBarButton.tapPublisher
            .sink { [weak self] in
                self?.presentAlertToSaveAlgorithm()
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
