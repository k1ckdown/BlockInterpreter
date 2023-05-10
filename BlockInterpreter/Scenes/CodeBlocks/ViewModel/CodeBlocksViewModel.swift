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
    var didUpdateTable = PassthroughSubject<Void, Never>()
    
    var cellViewModels: [[BlockCellViewModel]]
    
    private var subscriptions = Set<AnyCancellable>()
    private var selectedIndexPaths = CurrentValueSubject<[IndexPath], Never>([])
    private(set) var didGoToWorkspaceScreen = PassthroughSubject<Void, Never>()
    
    private let blocksSections = BlocksSection.allCases
    
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
    
    private func selectBlock(_ indexPath: IndexPath) {
        selectedIndexPaths.value.append(indexPath)
        cellViewModels[indexPath.section][indexPath.row].select()
    }
    
    private func deselectBlock(_ indexPath: IndexPath) {
        guard let index = selectedIndexPaths.value.firstIndex(of: indexPath) else { return }
        
        selectedIndexPaths.value.remove(at: index)
        cellViewModels[indexPath.section][indexPath.row].deselect()
    }
    
    private func deselectAllBlocks() {
        selectedIndexPaths.value.removeAll()
        cellViewModels.flatMap { $0 }.forEach { $0.deselect() }
    }
    
    private func updateCellViewModels() {
        cellViewModels[BlocksSection.variables.rawValue] = VariableBlockType.allCases.map {
            VariableBlockCellViewModel(variableType: $0.defaultType?.rawValue, style: .presentation)
        }
        
        cellViewModels[BlocksSection.conditions.rawValue] = ConditionBlockType.allCases.map {
            ConditionBlockCellViewModel(conditionBlockType: $0, style: .presentation)
        }
    }
    
    private func bind() {
        viewDidLoad
            .sink { [weak self] in
                self?.updateCellViewModels()
            }
            .store(in: &subscriptions)
        
        selectedIndexPaths
            .sink { [weak self] in
                self?.isOptionsMenuVisible.value = $0.count != 0
            }
            .store(in: &subscriptions)
        
        toggleSelectedIndexPath
            .sink { [weak self] in
                guard let self = self else { return }
                selectedIndexPaths.value.contains($0) == true ? deselectBlock($0) : selectBlock($0)
            }
            .store(in: &subscriptions)
        
        moveToWorkspace
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                isOptionsMenuVisible.send(false)
                didGoToWorkspaceScreen.send()
                deselectAllBlocks()
                didUpdateTable.send()
            }
            .store(in: &subscriptions)
    }
    
}
