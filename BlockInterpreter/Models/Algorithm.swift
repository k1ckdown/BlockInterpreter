import Foundation
////
////  Algorithm.swift
////  BlockInterpreter
////
//
//import Foundation

struct Algorithm: Codable {
    let name: String
    var blocks: [IBlock]
    let imageData: Data

    private enum CodingKeys: String, CodingKey {
        case name
        case blocks
        case imageData
    }
}
