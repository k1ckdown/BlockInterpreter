//
//  AlgorithmPreviewCell.swift
//  BlockInterpreter
//

import UIKit

final class AlgorithmPreviewCell: UICollectionViewCell {
    
    static let identifier = "AlgorithmPreviewCell"
    
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
        setupDocumentNameTitleLabel()
        setupPreviewImageView()
    }
    
    private func setupSuperView() {
        backgroundColor = .appMain
    }
    
    private func setupDocumentNameTitleLabel() {
        addSubview(documentNameTitleLabel)
        
        documentNameTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        documentNameTitleLabel.textColor = .appWhite
        documentNameTitleLabel.textAlignment = .center
        documentNameTitleLabel.backgroundColor = .appGray
        
        documentNameTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(8)
        }
    }
    
    private func setupPreviewImageView() {
        addSubview(previewImageView)
        
        previewImageView.contentMode = .scaleAspectFit
        
        previewImageView.snp.makeConstraints { make in
            make.top.equalTo(documentNameTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
