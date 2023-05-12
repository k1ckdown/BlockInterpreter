//
//  WorkspaceViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol WorkspaceViewModelType {
    var cellViewModels:  CurrentValueSubject<[BlockCellViewModel], Never> { get }
    
    var showConsole: PassthroughSubject<Void, Never> { get }
    var moveBlock: PassthroughSubject<(IndexPath, IndexPath), Never> { get }
    var addBlocks: PassthroughSubject<[BlockCellViewModel], Never> { get }
    
    var didUpdateBlocksTable: PassthroughSubject<Void, Never> { get }
}
