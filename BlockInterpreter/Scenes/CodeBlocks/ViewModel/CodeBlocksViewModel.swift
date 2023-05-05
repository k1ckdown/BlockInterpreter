//
//  CodeBlocksViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import Foundation

final class CodeBlocksViewModel {
    private let blocksSections = BlocksSection.allCases
    private(set) var variableBlockCellViewModels = [VariableBlockCellViewModel]()
}

extension CodeBlocksViewModel: CodeBlocksViewModelType {
    
    func viewDidLoad() {
        variableBlockCellViewModels = VariableBlockType.allCases.map { VariableBlockCellViewModel(variableType: $0.defaultType?.rawValue) }
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
        let section = blocksSections[section]
        
        switch section {
        case .variables:
            return variableBlockCellViewModels.count
        case .control:
            return 2
        case .loops:
            return 2
        case .arrays:
            return 1
        case .functions:
            return 3
        }
    }

}
