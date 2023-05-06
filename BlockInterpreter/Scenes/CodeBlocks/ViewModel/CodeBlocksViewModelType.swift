//
//  CodeBlocksViewModelType.swift
//  BlockInterpreter
//

import Foundation

protocol CodeBlocksViewModelType {
    var variableBlockCellViewModels: [VariableBlockCellViewModel] { get }
    var conditionBlockCellViewModels: [ConditionBlockCellViewModel] { get }
    
    func viewDidLoad()
    func getNumberOfSections() -> Int
    func getHeightForRowAt(_ indexPath: IndexPath) -> CGFloat
    func getSection(at indexPath: IndexPath) -> BlocksSection
    func getNumberOfItemsInSection(_ section: Int) -> Int
    func getTitleForHeaderInSection(_ section: Int) -> String
}
