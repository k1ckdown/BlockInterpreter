//
//  CodeBlocksViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import Foundation

final class CodeBlocksViewModel {
    private(set) var variableBlockCellViewModels = [VariableBlockCellViewModel]()
}

extension CodeBlocksViewModel: CodeBlocksViewModelType {
    func viewDidLoad() {
    }
}
