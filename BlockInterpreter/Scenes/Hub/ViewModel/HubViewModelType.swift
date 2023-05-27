//
//  HubViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol HubViewModelType {
    var cellViewModels: [AlgorithmPreviewCellViewModel] { get }
    var didSelectedAlgorithm: PassthroughSubject<IndexPath, Never> { get }
    var didUpdateCollection: PassthroughSubject<Void, Never> { get }
}
