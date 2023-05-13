//
//  CodeBlocksViewModel.swift
//  BlockInterpreter
//

import Foundation
import Combine

final class CodeBlocksViewModel: CodeBlocksViewModelType  {
    
    var viewDidLoad = PassthroughSubject<Void, Never>()
    var moveToWorkspace = PassthroughSubject<Void, Never>()
    var toggleSelectedIndexPath = PassthroughSubject<IndexPath, Never>()
    
    var isOptionsMenuVisible = CurrentValueSubject<Bool, Never>(false)
    var didUpdateTable = PassthroughSubject<Void, Never>()
    
    var cellViewModels: [[BlockCellViewModel]]
    
    private var subscriptions = Set<AnyCancellable>()
    private var selectedBlocks = CurrentValueSubject<[BlockCellViewModel], Never>([])
    private(set) var didGoToWorkspaceScreen = PassthroughSubject<[BlockCellViewModel], Never>()
    
    private let blocksSections = BlocksSection.allCases
    
    init() {
        cellViewModels = .init(repeating: .init(), count: blocksSections.count)
        bind()
    }
    
    func getNumberOfSections() -> Int {
        return blocksSections.count
    }
    
    func getNumberOfItemsInSection(_ section: Int) -> Int {
        return cellViewModels[section].count
    }
    
    func getHeightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return blocksSections[indexPath.section].heightForRow
    }
    
    func getTitleForHeaderInSection(_ section: Int) -> String {
        return blocksSections[section].title
    }
    
    func getSection(at indexPath: IndexPath) -> BlocksSection {
        return blocksSections[indexPath.section]
    }
    
}

extension CodeBlocksViewModel {
    private func selectBlock(_ block: BlockCellViewModel) {
        block.select()
        selectedBlocks.value.append(block)
    }
    
    private func deselectBlock(_ block: BlockCellViewModel) {
        block.deselect()
        selectedBlocks.value.removeAll(where: { $0 === block })
    }
    
    private func deselectAllBlocks() {
        selectedBlocks.value.removeAll()
        cellViewModels.flatMap { $0 }.forEach { $0.deselect() }
    }
    
    private func updateCellViewModels() {
        cellViewModels[BlocksSection.output.rawValue] = [OutputBlockCellViewModel(style: .presentation)]
        
        cellViewModels[BlocksSection.flow.rawValue] = FlowType.allCases.map {
            FlowBlockCellViewModel(flowType: $0, style: .presentation)
        }
        
        cellViewModels[BlocksSection.variables.rawValue] = VariableBlockType.allCases.map {
            VariableBlockCellViewModel(variableType: $0.defaultType, style: .presentation)
        }
        
        cellViewModels[BlocksSection.conditions.rawValue] = ConditionType.allCases.map {
            ConditionBlockCellViewModel(conditionType: $0, style: .presentation)
        }
        
        cellViewModels[BlocksSection.loops.rawValue] = [LoopBlockCellViewModel(style: .presentation)]
    }
    
    private func bind() {
        viewDidLoad
            .sink { [weak self] in
                self?.updateCellViewModels()
            }
            .store(in: &subscriptions)
        
        selectedBlocks
            .sink { [weak self] in
                self?.isOptionsMenuVisible.value = $0.count != 0
            }
            .store(in: &subscriptions)
        
        moveToWorkspace
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                isOptionsMenuVisible.send(false)
                didGoToWorkspaceScreen.send(selectedBlocks.value)
                deselectAllBlocks()
                didUpdateTable.send()
            }
            .store(in: &subscriptions)
        
        toggleSelectedIndexPath
            .compactMap() { [weak self] in
                self?.cellViewModels[$0.section][$0.row]
            }
            .sink { [weak self] block in
                guard let self = self else { return }
                selectedBlocks.value.contains(where: { $0 === block }) == true ? deselectBlock(block) : selectBlock(block)
            }
            .store(in: &subscriptions)
    }
    
}
