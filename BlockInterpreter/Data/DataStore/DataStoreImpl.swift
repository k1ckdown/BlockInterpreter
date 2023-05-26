//
//  DataStoreImpl.swift
//  BlockInterpreter
//

import Foundation

final class DataStoreImpl: DataStore {
    private let manager = FileManager.default
    private lazy var documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func doFileExist(documentName: String) -> Bool {
        manager.fileExists(atPath: documentsDirectory.appendingPathComponent(documentName).path)
    }
    
    func write<T: Encodable>(_ data: [T], to documentName: String) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(data)
            let jsonString = String(decoding: data, as: UTF8.self)
            
            saveDocument(contents: jsonString, documentName: documentName) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load<T: Decodable>(from documentName: String, completion: (Result<[T], Error>) -> Void) {
        let decoder = JSONDecoder()
        
        readDocument(documentName: documentName) { result in
            switch result {
            case .success(let data):
                
                do {
                    let blocks = try decoder.decode([T].self, from: data)
                    completion(.success(blocks))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveDocument(contents: String, documentName: String, completion: (Error?) -> Void) {
        let url = documentsDirectory.appendingPathComponent(documentName)
        
        do {
            try contents.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            completion(error)
        }
    }
    
    private func readDocument(documentName: String, completion: (Result<Data,Error>) -> Void) {
        let url = documentsDirectory.appendingPathComponent(documentName)
        
        do {
             let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
}


