//
//  WorkspaceViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol WorkspaceViewModelType {
    var introTitle: String { get }
    
    var isWiggleMode: CurrentValueSubject<Bool, Never> { get }
    var isIntroHidden: CurrentValueSubject<Bool, Never> { get }
    var cellViewModels: CurrentValueSubject<[BlockCellViewModel], Never> { get }
    
    var showConsole: PassthroughSubject<Void, Never> { get }
    var removeBlock: PassthroughSubject<BlockCellViewModel, Never> { get }
    var moveBlock: PassthroughSubject<(IndexPath, IndexPath), Never> { get }
    var addBlocks: PassthroughSubject<[BlockCellViewModel], Never> { get }
    var didBeginEditingBlocks: PassthroughSubject<Void, Never> { get }
    
    var didUpdateBlocksTable: PassthroughSubject<Void, Never> { get }
    var didDeleteRows: PassthroughSubject<[IndexPath], Never> { get }
}
