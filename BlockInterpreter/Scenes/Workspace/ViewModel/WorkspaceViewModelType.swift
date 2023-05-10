//
//  WorkspaceViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol WorkspaceViewModelType {
    var cellViewModels: [BlockCellViewModel] { get }
    
    var showConsole: PassthroughSubject<Void, Never> { get }
    var moveBlock: PassthroughSubject<(IndexPath, IndexPath), Never> { get }
}
