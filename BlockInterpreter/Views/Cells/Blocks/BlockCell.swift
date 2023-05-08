//
//  BlockCell.swift
//  BlockInterpreter
//

import UIKit

class BlockCell: UITableViewCell {
    
    var isSelectedState = false {
        didSet {
            updateAppearance()
        }
    }
    
    private enum Constants {
            enum ContainerView {
                static let cornerRadius: CGFloat = 15
                static let multiplierWidth: CGFloat = 0.7
            }
    }
    
    private(set) var containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupSuperView()
        setupContainerView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.layer.borderColor = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        isSelectedState = !isSelectedState
    }
    
    private func updateAppearance() {
        containerView.layer.borderColor = isSelectedState == true ? UIColor.orange.cgColor : .none
    }
    
    func configure(with viewModel: BlockCellViewModel) {
        isSelectedState = viewModel.isSelect
    }
    
    private func setupSuperView() {
        backgroundColor = .clear
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.cornerRadius = Constants.ContainerView.cornerRadius
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Constants.ContainerView.multiplierWidth)
            make.centerY.equalToSuperview()
        }
    }
}
