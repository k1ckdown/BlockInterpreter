//
//  HubViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol HubViewModelType {
    var cellViewModels: [AlgorithmPreviewCellViewModel] { get }
    var didUpdateCollection: PassthroughSubject<Void, Never> { get }
}
