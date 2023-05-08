//
//  CodeBlocksViewModel.swift
//  BlockInterpreter
//

import Foundation

final class CodeBlocksViewModel {
    
    var showOptionsMenu: (() -> Void)?
    var hideOptionsMenu: (() -> Void)?
    
    private let blocksSections = BlocksSection.allCases
    private var selectedIndexPaths = [IndexPath]()
    private(set) var cellViewModels: [[BlockCellViewModel]]
    
    init() {
        cellViewModels = .init(repeating: .init(), count: blocksSections.count)
    }
    
    private func selectIndexPath(_ indexPath: IndexPath) {
        selectedIndexPaths.append(indexPath)
        cellViewModels[indexPath.section][indexPath.row].select()
    }
    
    private func deselectIndexPath(_ indexPath: IndexPath) {
        guard let index = selectedIndexPaths.firstIndex(of: indexPath) else { return }
        
        selectedIndexPaths.remove(at: index)
        cellViewModels[indexPath.section][indexPath.row].deselect()
    }
    
}

extension CodeBlocksViewModel: CodeBlocksViewModelType {
    
    func viewDidLoad() {
        cellViewModels[BlocksSection.variables.rawValue] = VariableBlockType.allCases.map { VariableBlockCellViewModel(variableType: $0.defaultType?.rawValue) }
        cellViewModels[BlocksSection.conditions.rawValue] = ConditionBlockType.allCases.map { ConditionBlockCellViewModel(conditionBlockType: $0) }
    }
    
    func toggleSelectedIndexPath(_ indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            deselectIndexPath(indexPath)
        } else {
            selectIndexPath(indexPath)
        }
        
        selectedIndexPaths.count == 0 ? hideOptionsMenu?() : showOptionsMenu?()
    }
    
    func getNumberOfSections() -> Int {
        return blocksSections.count
    }
    
    func getSection(at indexPath: IndexPath) -> BlocksSection {
        return blocksSections[indexPath.section]
    }
    
    func getTitleForHeaderInSection(_ section: Int) -> String {
        return blocksSections[section].title
    }
    
    func getHeightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return blocksSections[indexPath.section].heightForRow
    }
    
    func getNumberOfItemsInSection(_ section: Int) -> Int {
        return cellViewModels[section].count
    }

}
