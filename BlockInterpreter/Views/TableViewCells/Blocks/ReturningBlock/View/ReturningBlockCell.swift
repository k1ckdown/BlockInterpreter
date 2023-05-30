//
//  ReturningBlockCell.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class ReturningBlockCell: LabelTFBlockCell {
    
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
    
    func configure(with viewModel: ReturningBlockCellViewModel) {
        super.configure(with: viewModel)
        
        labelTitle = viewModel.title
        textFieldText = viewModel.returnValue
        textFieldPlaceholder = viewModel.placeholder
    }
    
    private func setup() {
        setupContainerView()
        setupTextField()
        setupLabel()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .functionBlock
    }
    
    private func setupTextField() {
        textField.tintColor = .functionBlock
    }

    private func setupLabel() {
        label.font = .returningTitle
    }
}
