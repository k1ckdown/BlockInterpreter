//
//  AlgorithmPreviewCellViewModel.swift
//  BlockInterpreter
//

import UIKit

final class AlgorithmPreviewCellViewModel {
    
    private(set) var documentName: String
    private(set) var previewImageData: Data
    
    init(documentName: String, imageData: Data) {
        self.documentName = documentName
        previewImageData = imageData
    }
}
