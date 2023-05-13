//
//  BlockCell.swift
//  BlockInterpreter
//

import UIKit
import SnapKit

class BlockCell: UITableViewCell {
    
    var isSelectedState = false {
        didSet {
            updateAppearance()
        }
    }
    
    private enum Constants {
            enum ContainerView {
                static let borderWidth: CGFloat = 2.5
                static let insetLeading: CGFloat = 5
            }
    }
    
    private(set) var containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        containerView.snp.removeConstraints()
        containerView.layer.borderColor = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        isSelectedState = !isSelectedState
    }
    
    private func updateAppearance() {
        containerView.layer.borderColor = isSelectedState == true ? UIColor.appMain?.cgColor : UIColor.blockBorder?.cgColor
    }
    
    func configure(with viewModel: BlockCellViewModel) {
        isSelectedState = viewModel.isSelect
        containerView.layer.cornerRadius = viewModel.style.cornerRadius
        
        containerView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(viewModel.style.multiplierHeight())
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(viewModel.style.multiplierWidth(for: viewModel.type))
        }
        
        if viewModel.style == .presentation, viewModel.type != .flow {
            containerView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
            }
        } else if viewModel.style == .work {
            containerView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(Constants.ContainerView.insetLeading)
            }
        }
    }
    
    private func setup() {
        setupSuperView()
        setupContainerView()
    }
    
    private func setupSuperView() {
        backgroundColor = .clear
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = UIColor.blockBorder?.cgColor
        containerView.layer.borderWidth = Constants.ContainerView.borderWidth
    }
    
}
