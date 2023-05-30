//
//  WhileLoopBlockCell.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class WhileLoopBlockCell: LabelTFBlockCell {
    
    var subscriptions = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.removeAll()
    }
    
    func configure(with viewModel: WhileLoopBlockCellViewModel) {
        super.configure(with: viewModel)
        
        labelTitle = viewModel.title
        textFieldText = viewModel.loopCondition
        textFieldPlaceholder = viewModel.placeholder
    }
    
    private func setup() {
        setupContainerView()
        setupTextField()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .loopBlock
    }
    
    private func setupTextField() {
        textField.tintColor = .loopBlock
    }
}
