//
//  OutputBlockCell.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class OutputBlockCell: LabelTFBlockCell {
    
    static let identifier = "OutputBlockCell"
    
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
    
    func configure(with viewModel: OutputBlockCellViewModel) {
        super.configure(with: viewModel)
        
        labelTitle = viewModel.title
        textFieldText = viewModel.outputValue
        textFieldPlaceholder = viewModel.placeholder
    }
    
    private func setup() {
        setupContainerView()
        setupTextField()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .outputBlock
    }
    
    private func setupTextField() {
        textField.tintColor = .outputBlock
    }
    
}
