//
//  AppCoordinator.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow?
    private let transactionsRepository: TransactionsRepositoryType
    private let dateFormatter: DateFormatterType
    private let priceFormatter: NumberFormatterType
    private let styleGuide: StyleGuide
    private let navigationController = UINavigationController()

    // MARK: - Initializers

    init(
        window: UIWindow?,
        transactionsRepository: TransactionsRepositoryType,
        dateFormatter: DateFormatterType,
        priceFormatter: NumberFormatterType,
        styleGuide: StyleGuide
    ) {
        self.window = window
        self.transactionsRepository = transactionsRepository
        self.dateFormatter = dateFormatter
        self.priceFormatter = priceFormatter
        self.styleGuide = styleGuide
    }

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        showTransactions()
    }

    func close(animated: Bool, completion: (() -> Void)?) {
        assertionFailure("The close(animated:completion:) is not implemented by the AppCoordinator")
        completion?()
    }

    private func showTransactions() {
        let viewModel = TransactionsViewModel(
            transactionsRepository: transactionsRepository,
            dateFormatter: dateFormatter,
            priceFormatter: priceFormatter
        )
        viewModel.delegate = self
        let viewController = TransactionsViewController(viewModel: viewModel, styleGuide: styleGuide)
        navigationController.viewControllers = [viewController]
    }

    private func showTransaction(_ transaction: Transaction) {
        // TODO: - show Transaction screen
        /*let viewModel = TransactionViewModel(transaction: transaction)
        viewModel.delegate = self
        let viewController = TransactionViewController(viewModel: viewModel)
        navigationController.present(viewController, animated: true, completion: nil)*/
    }
}

extension AppCoordinator: TransactionsViewModelDelegate {
    func didSelect(transaction: Transaction, from viewModel: TransactionsViewModel) {
        showTransaction(transaction)
    }
}
