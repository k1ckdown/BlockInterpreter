//
//  AlgorithmPreviewCell.swift
//  BlockInterpreter
//

import UIKit

final class AlgorithmPreviewCell: UICollectionViewCell, ReuseIdentifier {
    
    private enum Constants {
        
            enum SuperView {
                static let cornerRadius: CGFloat = 15
            }
            
            enum DocumentNameTitleLabel {
                static let insetSide: CGFloat = 10
                static let height: CGFloat = 30
                static let insetTop: CGFloat = 8
                static let cornerRadius: CGFloat = 8
            }
            
            enum PreviewImageView {
                static let insetTop: CGFloat = 10
                static let insetSide: CGFloat = 10
                static let insetBottom: CGFloat = 5
            }
        
    }
    
    private let documentNameTitleLabel = UILabel()
    private let previewImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: AlgorithmPreviewCellViewModel) {
        documentNameTitleLabel.text = viewModel.documentName
        previewImageView.image = UIImage(data: viewModel.previewImageData)
    }
    
    private func setup() {
        setupSuperView()
        setupDocumentNameTitleLabel()
        setupPreviewImageView()
    }
    
    private func setupSuperView() {
        backgroundColor = .appMain
        layer.cornerRadius = Constants.SuperView.cornerRadius
    }
    
    private func setupDocumentNameTitleLabel() {
        addSubview(documentNameTitleLabel)
        
        documentNameTitleLabel.font = .documentTitle
        documentNameTitleLabel.textColor = .appWhite
        documentNameTitleLabel.textAlignment = .center
        documentNameTitleLabel.backgroundColor = .appGray
        layer.cornerRadius = Constants.DocumentNameTitleLabel.cornerRadius
        clipsToBounds = true
        
        documentNameTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.DocumentNameTitleLabel.insetSide)
            make.height.equalTo(Constants.DocumentNameTitleLabel.height)
            make.top.equalToSuperview().offset(Constants.DocumentNameTitleLabel.insetTop)
        }
    }
    
    private func setupPreviewImageView() {
        addSubview(previewImageView)
        
        previewImageView.contentMode = .scaleAspectFit
        
        previewImageView.snp.makeConstraints { make in
            make.top.equalTo(documentNameTitleLabel.snp.bottom).offset(Constants.PreviewImageView.insetTop)
            make.leading.trailing.equalToSuperview().inset(Constants.PreviewImageView.insetSide)
            make.bottom.equalToSuperview().inset(Constants.PreviewImageView.insetBottom)
        }
    }
}
