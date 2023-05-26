//
//  HubViewController.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class HubViewController: UIViewController {
    
    private lazy var savedAlgorithmsCollectionView: UICollectionView = {
        let layout = AlgorithmPreviewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let viewModel: HubViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: HubViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        setupSuperView()
        setupSavedAlgorithmsCollectionView()
    }
    
    private func setupSuperView() {
        view.setGradientBackground()
    }
    
    private func setupSavedAlgorithmsCollectionView() {
        view.addSubview(savedAlgorithmsCollectionView)
        
        savedAlgorithmsCollectionView.dataSource = self
        savedAlgorithmsCollectionView.backgroundColor = .clear
        savedAlgorithmsCollectionView.showsVerticalScrollIndicator = false
        savedAlgorithmsCollectionView.showsHorizontalScrollIndicator = false
        savedAlgorithmsCollectionView.register(
            AlgorithmPreviewCell.self,
            forCellWithReuseIdentifier: AlgorithmPreviewCell.identifier)
        
        savedAlgorithmsCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

}

extension HubViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.cellViewModels[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlgorithmPreviewCell.identifier,
            for: indexPath
        ) as? AlgorithmPreviewCell
        else { return .init() }
        
        cell.configure(with: cellViewModel)
        
        return cell
    }
}

private extension HubViewController {
    func setupBindings() {
        viewModel.didUpdateCollection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.savedAlgorithmsCollectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
}
