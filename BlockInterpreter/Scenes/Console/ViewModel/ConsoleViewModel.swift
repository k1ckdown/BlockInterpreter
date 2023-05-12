//
//  ConsoleViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class ConsoleViewModel: ConsoleViewModelType {
    
    var viewDidLoad = PassthroughSubject<Void, Never>()
    
    var didUpdateConsoleContent = PassthroughSubject<String, Never>()
    
    private let outputText: String
    private var subscriptions = Set<AnyCancellable>()
    
    init(outputText: String) {
        self.outputText = outputText
        bind()
    }
    
}

extension ConsoleViewModel {
    private func bind() {
        viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                didUpdateConsoleContent.send(outputText)
            }
            .store(in: &subscriptions)
    }
}
