//
//  CodeBlocksViewModelType.swift
//  BlockInterpreter
//

import Foundation

protocol CodeBlocksViewModelType {
    var cellViewModels: [[BlockCellViewModel]] { get }
    
    var showOptionsMenu: (() -> Void)? { get set }
    var hideOptionsMenu: (() -> Void)? { get set }
    
    func viewDidLoad()
    func toggleSelectedIndexPath(_ indexPath: IndexPath)
    func getNumberOfSections() -> Int
    func getHeightForRowAt(_ indexPath: IndexPath) -> CGFloat
    func getSection(at indexPath: IndexPath) -> BlocksSection
    func getNumberOfItemsInSection(_ section: Int) -> Int
    func getTitleForHeaderInSection(_ section: Int) -> String
}
