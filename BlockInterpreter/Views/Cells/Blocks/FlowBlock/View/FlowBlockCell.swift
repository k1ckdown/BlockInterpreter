//
//  FlowBlockCell.swift
//  BlockInterpreter
//

import UIKit

final class FlowBlockCell: BlockCell {
    
    static let identifier = "FlowBlockCell"
    
    private enum Constants {
            enum ContainerView {
                static let insetSide: CGFloat = 15
            }
    }

    private let blockTitleLabel = BlockTitleLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: FlowBlockCellViewModel) {
        super.configure(with: viewModel)
        
        blockTitleLabel.text = viewModel.title
        containerView.backgroundColor = viewModel.flowBlockStyle.backgroundColor
        
        guard viewModel.style == .presentation else { return }

        if viewModel.flowType == .begin {
            containerView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(Constants.ContainerView.insetSide)
            }
        } else {
            containerView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(Constants.ContainerView.insetSide)
            }
        }
    }
    
    private func setup() {
        setupBlockTitleLabelLabel()
    }
    
    private func setupBlockTitleLabelLabel() {
        containerView.addSubview(blockTitleLabel)
        
        blockTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
