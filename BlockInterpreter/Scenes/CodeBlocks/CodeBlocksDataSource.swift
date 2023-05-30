//
//  CodeBlocksDataSource.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 31.05.2023.
//

import UIKit

final class CodeBlocksDataSource: NSObject {
    
    private let viewModel: CodeBlocksViewModelType
    
    init(with viewModel: CodeBlocksViewModelType) {
        self.viewModel = viewModel
    }
    
}

extension CodeBlocksDataSource: UITableViewDataSource {
    
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
            
            return cell
            
        case .commonFlow:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FlowBlockCell.reuseIdentifier,
                    for: indexPath
                ) as? FlowBlockCell,
                let cellViewModel = cellViewModel as? FlowBlockCellViewModel
            else { return .init() }

            cell.configure(with: cellViewModel)
            return cell
            
        case .variables:
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
            
            return cell
            
        case .conditions:
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

            return cell
            
        case .conditionFlow:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FlowBlockCell.reuseIdentifier,
                    for: indexPath
                ) as? FlowBlockCell,
                let cellViewModel = cellViewModel as? FlowBlockCellViewModel
            else { return .init() }
            
            cell.configure(with: cellViewModel)
            
            return cell
            
        case .loops:
            
            if cellViewModel.type.isEqualTo(.loop(.whileLoop)) {
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
                
                return cell
            } else if cellViewModel.type.isEqualTo(.loop(.forLoop)) {
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
                
                return cell
            } else {
                return .init()
            }
            
        case .functions:
            if cellViewModel.type.isEqualTo(.function) {
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
                
                return cell
                
            } else if cellViewModel.type.isEqualTo(.returnBlock) {
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
                
                return cell
                
            } else {
                return .init()
            }
            
        case .arrayMethods:
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
            
            return cell
        }
    }
    
}
