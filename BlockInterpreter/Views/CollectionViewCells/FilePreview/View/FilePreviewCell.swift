//
//  FilePreviewCell.swift
//  BlockInterpreter
//

import UIKit

final class FilePreviewCell: UICollectionViewCell {
    
    static let identifier = "FilePreviewCell"
    
    private let documentNameTitleLabel = UILabel()
    private let previewImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        documentNameTitleLabel.text = "Tomsk"
        documentNameTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        documentNameTitleLabel.textColor = .appBlack
        documentNameTitleLabel.textAlignment = .center
        documentNameTitleLabel.backgroundColor = .orange
        
        documentNameTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(8)
        }
    }
    
    private func setupPreviewImageView() {
        addSubview(previewImageView)
        
        previewImageView.image = UIImage(named: "intro-blocks")
        previewImageView.contentMode = .scaleAspectFill
        
        previewImageView.snp.makeConstraints { make in
            make.top.equalTo(documentNameTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
