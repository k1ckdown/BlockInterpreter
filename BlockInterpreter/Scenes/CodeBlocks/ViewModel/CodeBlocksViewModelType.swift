//
//  CodeBlocksViewModelType.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 30.04.2023.
//

import Foundation

protocol CodeBlocksViewModelType {
    var variableBlockCellViewModels: [VariableBlockCellViewModel] { get }
    
    func viewDidLoad()
}
