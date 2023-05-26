//
//  SettingsViewController.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {
    
    private lazy var savedAlgorithmsCollectionView: UICollectionView = {
        let layout = FilePreviewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let viewModel: SettingsViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: SettingsViewModelType) {
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
            FilePreviewCell.self,
            forCellWithReuseIdentifier: FilePreviewCell.identifier)
        
        savedAlgorithmsCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

}

extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilePreviewCell.identifier,
            for: indexPath
        ) as? FilePreviewCell
        else { return .init() }
        
        return cell
    }
}

private extension SettingsViewController {
    func setupBindings() {
        viewModel.didUpdateCollection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.savedAlgorithmsCollectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
}
