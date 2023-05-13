//
//  FlowBlockCell.swift
//  BlockInterpreter
//

import UIKit

class FlowBlockCell: BlockCell {
    
    static let identifier = "FlowBlockCell"
    
    private enum Constants {
        
        enum ContainerView {
            static let borderWidth: CGFloat = 0
        }
        
        enum BlockTitleLabel {
            static let insetSide: CGFloat = 15
            static let borderWidth: CGFloat = 3
            static let cornerRadius: CGFloat = 15
            static let multiplierWidth: CGFloat = 0.6
        }
        
    }

    private let blockTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        blockTitleLabel.snp.removeConstraints()
    }
    
    override func updateAppearance() {
        blockTitleLabel.layer.borderColor = isSelectedState == true ? UIColor.appMain?.cgColor : UIColor.blockBorder?.cgColor
    }
    
    func configure(with viewModel: FlowBlockCellViewModel) {
        super.configure(with: viewModel)
        
        blockTitleLabel.text = viewModel.title
        blockTitleLabel.backgroundColor = viewModel.flowBlockStyle.backgroundColor
        
        blockTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Constants.BlockTitleLabel.multiplierWidth)
        }
        
        guard viewModel.style == .presentation else { return }

        if viewModel.flowType == .begin {
            blockTitleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(Constants.BlockTitleLabel.insetSide)
            }
        } else {
            blockTitleLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(Constants.BlockTitleLabel.insetSide)
            }
        }
    }
    
    private func setup() {
        setupContainerView()
        setupBlockTitleLabelLabel()
    }
    
    private func setupContainerView() {
        containerView.layer.borderWidth = Constants.ContainerView.borderWidth
    }
    
    private func setupBlockTitleLabelLabel() {
        containerView.addSubview(blockTitleLabel)
        
        blockTitleLabel.font = .blockTitle
        blockTitleLabel.textColor = .appBlack
        blockTitleLabel.textAlignment = .center
        blockTitleLabel.clipsToBounds = true
        blockTitleLabel.layer.borderWidth = Constants.BlockTitleLabel.borderWidth
        blockTitleLabel.layer.borderColor = UIColor.blockBorder?.cgColor
        blockTitleLabel.layer.cornerRadius = Constants.BlockTitleLabel.cornerRadius
    }

}
