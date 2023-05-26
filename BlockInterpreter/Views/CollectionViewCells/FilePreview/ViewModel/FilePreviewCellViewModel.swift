//
//  FilePreviewCellViewModel.swift
//  BlockInterpreter
//

import UIKit

final class FilePreviewCellViewModel {
    
    private(set) var documentName: String
    private(set) var previewImage: UIImage?
    
    init(documentName: String) {
        self.documentName = documentName
    }
}
