//
//  ConsoleViewController.swift
//  BlockInterpreter
//

import UIKit
import Combine

final class ConsoleViewController: UIViewController {
    
    private let outputTextView = UITextView()
    
    private let viewModel: ConsoleViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    init(with viewModel: ConsoleViewModelType) {
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
        viewModel.viewDidLoad.send()
    }

    private func setupUI() {
        setupOutputLabel()
        setupSuperView()
        setupNavigationBar()
        setupStopBarButton()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .appBackground
    }
    
    private func setupOutputLabel() {
        view.addSubview(outputTextView)
        
        outputTextView.textColor = .appWhite
        outputTextView.backgroundColor = .clear
        outputTextView.isEditable = false
        outputTextView.font = .outputText
        outputTextView.textColor = .appWhite
        outputTextView.tintColor = .appMain
        
        outputTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.appMain ?? .white,
            .font: UIFont.systemFont(ofSize: 19, weight: .bold)
        ]
    }
    
    private func setupStopBarButton() {
        let stopBarButton = UIBarButtonItem(image: UIImage(systemName: "square.fill"), style: .plain, target: self, action: nil)
        stopBarButton.tintColor = .red
        navigationItem.rightBarButtonItem = stopBarButton
    }

}

private extension ConsoleViewController {
    func setupBindings() {
        viewModel.didUpdateConsoleContent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.outputTextView.text = $0 + "\n\(LocalizedStrings.endProgramm())"
            }
            .store(in: &subscriptions)
        
    }
}
