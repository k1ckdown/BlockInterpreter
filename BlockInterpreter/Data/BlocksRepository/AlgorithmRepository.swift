//
//  AlgorithmRepository.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol AlgorithmRepository {
    var algorithms: CurrentValueSubject<[Algorithm], Never> { get }
    var addAlgorithm: PassthroughSubject<Algorithm, Never> { get }
    
    func doFileExist(documentName: String) -> Bool
}
