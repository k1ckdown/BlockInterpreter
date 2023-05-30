//
//  WorkspaceDataSource.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 31.05.2023.
//

import UIKit

final class WorkspaceDataSource: NSObject {
    
    private let viewModel: WorkspaceViewModelType
    
    init(with viewModel: WorkspaceViewModelType) {
        self.viewModel = viewModel
    }
    
}

extension WorkspaceDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModels.value[indexPath.row]
        
        switch cellViewModel.type {
        case .output:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: OutputBlockCell.reuseIdentifier,
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .flow:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FlowBlockCell.reuseIdentifier,
                    for: indexPath
                ) as? FlowBlockCell,
                let cellViewModel = cellViewModel as? FlowBlockCellViewModel
            else { return .init() }
            
            cell.configure(with: cellViewModel)
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .variable:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: VariableBlockCell.reuseIdentifier,
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .condition:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ConditionBlockCell.reuseIdentifier,
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .loop(.whileLoop):
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: WhileLoopBlockCell.reuseIdentifier,
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .loop(.forLoop):
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ForLoopBlockCell.reuseIdentifier,
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
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .function:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FunctionBlockCell.reuseIdentifier,
                    for: indexPath
                ) as? FunctionBlockCell,
                let cellViewModel = cellViewModel as? FunctionBlockCellViewModel
            else { return .init() }
            
            cell.configure(with: cellViewModel)
                        
            cell.functionNameTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.functionName = text
                }
                .store(in: &cell.subscriptions)
            
            cell.argumentsTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.argumentsString = text
                }
                .store(in: &cell.subscriptions)
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .returnBlock:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ReturningBlockCell.reuseIdentifier,
                    for: indexPath
                ) as? ReturningBlockCell,
                let cellViewModel = cellViewModel as? ReturningBlockCellViewModel
            else { return .init() }
            
            cell.configure(with: cellViewModel)
            
            cell.textField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.returnValue = text
                }
                .store(in: &cell.subscriptions)
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
            
        case .arrayMethod:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ArrayMethodBlockCell.reuseIdentifier,
                    for: indexPath
                ) as? ArrayMethodBlockCell,
                let cellViewModel = cellViewModel as? ArrayMethodBlockCellViewModel
            else { return .init() }
            
            cell.configure(with: cellViewModel)
            
            cell.arrayNameTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.arrayName = text
                }
                .store(in: &cell.subscriptions)
            
            cell.valueTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak cellViewModel] text in
                    guard let text = text else { return }
                    cellViewModel?.value = text
                }
                .store(in: &cell.subscriptions)
            
            cell.deleteButton.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.removeBlock.send(cellViewModel)
                }
                .store(in: &cell.subscriptions)
            
            return cell
        }
    }
    
}
