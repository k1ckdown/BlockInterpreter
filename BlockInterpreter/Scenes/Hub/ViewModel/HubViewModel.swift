//
//  HubViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class HubViewModel: HubViewModelType {
    
    var cellViewModels = [AlgorithmPreviewCellViewModel]()
    var didSelectedAlgorithm = PassthroughSubject<IndexPath, Never>()
    var didUpdateCollection = PassthroughSubject<Void, Never>()
    var algorithmBlocks = [[IBlock]]()
    
    private(set) var didUpdateWorkspace = PassthroughSubject<[IBlock], Never>()
    private(set) var updateSavedAlgorithms = PassthroughSubject<[Algorithm], Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension HubViewModel {
    private func bind() {
        updateSavedAlgorithms
            .sink { [weak self] algorithms in
                guard let self = self else { return }
                
                algorithms.forEach {
                    self.cellViewModels.append(AlgorithmPreviewCellViewModel(documentName: $0.name, imageData: $0.imageData))
                    self.algorithmBlocks.append($0.getBlocks())
                }
                
                didUpdateCollection.send()
            }
            .store(in: &subscriptions)
        
        didSelectedAlgorithm
            .sink { [weak self] in
                guard let self = self else { return }
//                print("didSelectedAlgorithm \(algorithmBlocks)")
                print("didSelectedAlgorithm \(algorithmBlocks[$0.item])")
                didUpdateWorkspace.send(algorithmBlocks[$0.item])
            }
            .store(in: &subscriptions)
    }
}
