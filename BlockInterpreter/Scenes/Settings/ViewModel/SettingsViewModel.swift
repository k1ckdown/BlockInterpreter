//
//  SettingsViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class SettingsViewModel {
    var cellViewModels = [FilePreviewCellViewModel]()
    var didUpdateCollection = PassthroughSubject<Void, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
}

extension SettingsViewModel: SettingsViewModelType {
    
}
