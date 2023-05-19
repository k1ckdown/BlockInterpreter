//
//  CodeBlocksViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol CodeBlocksViewModelType {
    var cellViewModels: [[BlockCellViewModel]] { get }
    
    var isOptionsMenuVisible: CurrentValueSubject<Bool, Never> { get }
    var didUpdateTable: PassthroughSubject<Void, Never> { get }
    var didUpdateMenuTitle: PassthroughSubject<String, Never> { get }

    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    var moveToWorkspace: PassthroughSubject<Void, Never> { get }
    var toggleSelectedIndexPath: PassthroughSubject<IndexPath, Never> { get }

    func getNumberOfSections() -> Int
    func getNumberOfItemsInSection(_ section: Int) -> Int
    func getSection(at indexPath: IndexPath) -> BlocksSection
    func getHeightForRowAt(_ indexPath: IndexPath) -> CGFloat
    func getTitleForHeaderInSection(_ section: Int) -> String
}
