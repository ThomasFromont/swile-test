//
//  AppCoordinator.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow?
    private let transfersProvider: TransfersProvider
    private let navigationController = UINavigationController()

    // MARK: - Initializers

    init(window: UIWindow?, transfersProvider: TransfersProvider) {
        self.window = window
        self.transfersProvider = transfersProvider
    }

    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        showTransfers()
    }

    func close(animated: Bool, completion: (() -> Void)?) {
        assertionFailure("The close(animated:completion:) is not implemented by the AppCoordinator")
        completion?()
    }

    private func showTransfers() {
        // TODO: - show Transfers screen
        /*let viewModel = TransfersViewModel(transfersProvider: transfersProvider)
        viewModel.delegate = self
        let viewController = TransfersViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]*/
    }

    private func showTransfer(_ transfer: Transfer) {
        // TODO: - show Transfer screen
        /*let viewModel = TransferViewModel(transfer: transfer)
        viewModel.delegate = self
        let viewController = TransferViewController(viewModel: viewModel)
        navigationController.present(viewController, animated: true, completion: nil)*/
    }
}

// TODO: - implement Transfers Delegate
/*extension AppCoordinator: TransfersViewModelDelegate {
    func didSelect(transfer: Transfer, from viewModel: TransfersViewModel) {
        showTransfer(transfer)
    }
}*/
