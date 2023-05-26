//
//  AlgorithmRepository.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol AlgorithmRepository {
    var addAlgorithm: PassthroughSubject<Algorithm, Never> { get }
    
    func doFileExist(documentName: String) -> Bool
//    func write<T: Encodable>(_ data: [T], to documentName: String)
//    func load<T: Decodable>(from documentName: String, completion: (Result<[T], Error>) -> Void)
}
