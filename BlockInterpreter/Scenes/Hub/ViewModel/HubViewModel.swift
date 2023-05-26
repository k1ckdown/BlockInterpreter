//
//  HubViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class HubViewModel: HubViewModelType {
    
    var cellViewModels = [AlgorithmPreviewCellViewModel]()
    var didUpdateCollection = PassthroughSubject<Void, Never>()
    var blocks = [IBlock]()
    
    private(set) var updateSavedAlgorithms = PassthroughSubject<[Algorithm], Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension HubViewModel {
    private func bind() {
        updateSavedAlgorithms
            .sink { [weak self] in
                guard let self = self else { return }
                
                cellViewModels = $0.map {
                    AlgorithmPreviewCellViewModel(documentName: $0.name, imageData: $0.imageData)
                }
                
                didUpdateCollection.send()
            }
            .store(in: &subscriptions)
    }
}
