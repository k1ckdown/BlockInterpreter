//
//  ConsoleViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol ConsoleViewModelType {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    
    var didUpdateConsoleContent: PassthroughSubject<String, Never> { get }
}
