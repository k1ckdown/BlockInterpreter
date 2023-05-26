//
//  SettingsViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol SettingsViewModelType {
    var cellViewModels: [FilePreviewCellViewModel] { get }
    var didUpdateCollection: PassthroughSubject<Void, Never> { get }
}
