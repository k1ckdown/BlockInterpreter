//
//  CodeBlocksViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class CodeBlocksViewModel: CodeBlocksViewModelType  {
    
    var viewDidLoad = PassthroughSubject<Void, Never>()
    var moveToWorkspace = PassthroughSubject<Void, Never>()
    var toggleSelectedIndexPath = PassthroughSubject<IndexPath, Never>()
    
    var isOptionsMenuVisible = CurrentValueSubject<Bool, Never>(false)
    
    private var subscriptions = Set<AnyCancellable>()
    private var selectedIndexPaths = CurrentValueSubject<[IndexPath], Never>([])
    private(set) var didGoToWorkspaceScreen = PassthroughSubject<Void, Never>()
    
    private let blocksSections = BlocksSection.allCases
    private(set) var cellViewModels: [[BlockCellViewModel]]
    
    init() {
        cellViewModels = .init(repeating: .init(), count: blocksSections.count)
        bind()
    }
    
    func getNumberOfSections() -> Int {
        return blocksSections.count
    }
    
    func getNumberOfItemsInSection(_ section: Int) -> Int {
        return cellViewModels[section].count
    }
    
    func getHeightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return blocksSections[indexPath.section].heightForRow
    }
    
    func getTitleForHeaderInSection(_ section: Int) -> String {
        return blocksSections[section].title
    }
    
    func getSection(at indexPath: IndexPath) -> BlocksSection {
        return blocksSections[indexPath.section]
    }
    
}

extension CodeBlocksViewModel {
    
    private func selectIndexPath(_ indexPath: IndexPath) {
        selectedIndexPaths.value.append(indexPath)
        cellViewModels[indexPath.section][indexPath.row].select()
    }
    
    private func deselectIndexPath(_ indexPath: IndexPath) {
        guard let index = selectedIndexPaths.value.firstIndex(of: indexPath) else { return }
        
        selectedIndexPaths.value.remove(at: index)
        cellViewModels[indexPath.section][indexPath.row].deselect()
    }
    
    private func updateCellViewModels() {
        cellViewModels[BlocksSection.variables.rawValue] = VariableBlockType.allCases.map {
            VariableBlockCellViewModel(variableType: $0.defaultType?.rawValue)
        }
        
        cellViewModels[BlocksSection.conditions.rawValue] = ConditionBlockType.allCases.map {
            ConditionBlockCellViewModel(conditionBlockType: $0)
        }
    }
    
    private func bind() {
        selectedIndexPaths
            .sink(receiveValue: { [weak self] in
                self?.isOptionsMenuVisible.value = $0.count != 0
            })
            .store(in: &subscriptions)
        
        viewDidLoad
            .sink(receiveValue: { [weak self] in self?.updateCellViewModels()})
            .store(in: &subscriptions)
        
        moveToWorkspace
            .sink(receiveValue: { [weak self] _ in
                self?.isOptionsMenuVisible.send(false)
                self?.didGoToWorkspaceScreen.send()
            })
            .store(in: &subscriptions)
        
        toggleSelectedIndexPath
            .sink { [weak self] in
                self?.selectedIndexPaths.value.contains($0) == true ? self?.deselectIndexPath($0) : self?.selectIndexPath($0)
            }
            .store(in: &subscriptions)
    }
    
}
