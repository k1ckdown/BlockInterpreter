//
//  DataStore.swift
//  BlockInterpreter
//

import Foundation

protocol DataStore {
    func doFileExist(documentName: String) -> Bool
    func write<T: Encodable>(_ data: [T], to documentName: String)
    func load<T: Decodable>(from documentName: String, completion: (Result<[T], Error>) -> Void)
}
