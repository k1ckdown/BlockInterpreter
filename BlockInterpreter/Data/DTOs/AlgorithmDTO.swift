//
//  AlgorithmDTO.swift
//  BlockInterpreter
//

import Foundation

struct AlgorithmDTO: Codable {
    let name: String
    let blocks: [IBlock]
    let imageData: Data
    
    private enum CodingKeys: String, CodingKey {
        case name
        case blocks
        case imageData
    }
    
    func toAlgorithm() -> Algorithm {
        return Algorithm(name: name, blocks: blocks, imageData: imageData)
    }
}
