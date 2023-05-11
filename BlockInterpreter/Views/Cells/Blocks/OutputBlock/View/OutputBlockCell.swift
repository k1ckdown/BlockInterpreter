//
//  OutputBlockCell.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 11.05.2023.
//

import UIKit
import Combine

final class OutputBlockCell: BlockCell {
    
    static let identifier = "OutputBlockCell"
    
    var subscriptions = Set<AnyCancellable>()
    
    private let outputLabel = UILabel()
    private(set) var outputTextField = BlockTextField()
    
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
        
        outputTextField.text = viewModel.outputText
        outputTextField.placeholder = viewModel.outputPlaceholder
    }
    
    private func setup() {
        setupContainerView()
        setupOutputTextField()
        setupOutputLabel()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .outputBlock
    }
    
    private func setupOutputTextField() {
        containerView.addSubview(outputTextField)
        
        outputTextField.tintColor = .outputBlock
        
        outputTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func setupOutputLabel() {
        containerView.addSubview(outputLabel)
        
        outputLabel.text = "PRINT"
        outputLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        outputLabel.textColor = .appBlack
        outputLabel.textAlignment = .center
        outputLabel.adjustsFontSizeToFitWidth = true
        
        outputLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.bottom.equalToSuperview()
        }
    }
    
}
