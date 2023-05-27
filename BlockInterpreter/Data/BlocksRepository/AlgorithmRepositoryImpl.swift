//
//  AlgorithmRepositoryImpl.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class AlgorithmRepositoryImpl: AlgorithmRepository {
    
    var algorithms = CurrentValueSubject<[Algorithm], Never>([])
    
    var removeAlgorithm = PassthroughSubject<Void, Never>()
    var updateAlgorithm = PassthroughSubject<Void, Never>()
    var addAlgorithm = PassthroughSubject<Algorithm, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    private let manager = FileManager.default
    private lazy var documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    init() {
        loadAlgorithms()
        setupBindings()
    }
    
    func doFileExist(documentName: String) -> Bool {
        manager.fileExists(atPath: documentsDirectory.appendingPathComponent(documentName).path)
    }
    
    func getAlgorithm(at index: Int) -> Algorithm? {
        guard index < algorithms.value.count else { return nil }
        return algorithms.value[index]
    }
    
    private func write(_ algorithm: Algorithm, to documentName: String) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(algorithm)
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
    
    private func loadAlgorithm(from documentName: String, completion: (Result<Algorithm, Error>) -> Void) {
        let decoder = JSONDecoder()
        
        readDocument(documentName: documentName) { result in
            switch result {
            case .success(let data):
                
                do {
                    let algorithm = try decoder.decode(Algorithm.self, from: data)
                    completion(.success(algorithm))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func loadAlgorithms() {
        do {
            if !manager.fileExists(atPath: documentsDirectory.path) {
                try manager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            
            let fileUrls = try manager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            
            for url in fileUrls {
                let documentName = url.lastPathComponent
//                removeAlgorithm(from: documentName)
                loadAlgorithm(from: documentName) { result in
                    switch result {
                    case .success(let algorithm):
                        algorithms.value.append(algorithm)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
        }

    }
    
    private func removeAlgorithm(from documentName: String) {
        let url = documentsDirectory.appendingPathComponent(documentName)
        
        do {
            try manager.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
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

private extension AlgorithmRepositoryImpl {
    func setupBindings() {
        addAlgorithm.sink { [weak self] in
            guard let self = self else { return }
            
            algorithms.value.append($0)
            write($0, to: $0.name)
        }
        .store(in: &subscriptions)
    }
}


