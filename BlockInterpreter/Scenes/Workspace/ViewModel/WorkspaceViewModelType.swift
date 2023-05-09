//
//  WorkspaceViewModelType.swift
//  BlockInterpreter
//

import Foundation
import Combine

protocol WorkspaceViewModelType {
    var showConsole: PassthroughSubject<Void, Never> { get }
}
