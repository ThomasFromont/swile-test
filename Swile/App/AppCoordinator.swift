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
    private let imageProvider: ImageProviderType
    private let styleGuide: StyleGuide
    private let navigationController = UINavigationController()

    // MARK: - Initializers

    init(
        window: UIWindow?,
        transactionsRepository: TransactionsRepositoryType,
        dateFormatter: DateFormatterType,
        priceFormatter: NumberFormatterType,
        imageProvider: ImageProviderType,
        styleGuide: StyleGuide
    ) {
        self.window = window
        self.transactionsRepository = transactionsRepository
        self.dateFormatter = dateFormatter
        self.priceFormatter = priceFormatter
        self.imageProvider = imageProvider
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
            priceFormatter: priceFormatter,
            imageProvider: imageProvider
        )
        viewModel.delegate = self
        let viewController = TransactionsViewController(viewModel: viewModel, styleGuide: styleGuide)
        navigationController.viewControllers = [viewController]
    }

    private func showTransactionDetails(_ transaction: Transaction) {
        let viewModel = TransactionDetailsViewModel(
            transaction: transaction,
            dateFormatter: dateFormatter,
            priceFormatter: priceFormatter,
            imageProvider: imageProvider
        )
        viewModel.delegate = self
        let viewController = TransactionDetailsViewController(viewModel: viewModel, styleGuide: styleGuide)
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }
}

extension AppCoordinator: TransactionsViewModelDelegate {
    func didSelect(transaction: Transaction, from viewModel: TransactionsViewModel) {
        showTransactionDetails(transaction)
    }
}

extension AppCoordinator: TransactionDetailsViewModelDelegate {
    func didSelectClose(from viewModel: TransactionDetailsViewModel) {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
