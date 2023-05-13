//
//  OutputBlockCell.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class OutputBlockCell: BlockCell {
    
    static let identifier = "OutputBlockCell"
    
    var subscriptions = Set<AnyCancellable>()
    
    private enum Constants {
            enum OutputLabel {
                static let insetLeading: CGFloat = 30
            }
        
            enum OutputTextField {
                static let insetTrailing: CGFloat = 30
                static let insetTopBottom: CGFloat = 12
                static let multiplierWidth: CGFloat = 0.6
            }
    }
    
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
            make.top.bottom.equalToSuperview().inset(Constants.OutputTextField.insetTopBottom)
            make.width.equalToSuperview().multipliedBy(Constants.OutputTextField.multiplierWidth)
            make.trailing.equalToSuperview().inset(Constants.OutputTextField.insetTrailing)
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
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.OutputLabel.insetLeading)
        }
    }
    
}
