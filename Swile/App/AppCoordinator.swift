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
    private let styleGuide: StyleGuide
    private let navigationController = UINavigationController()

    // MARK: - Initializers

    init(window: UIWindow?, transfersProvider: TransfersProvider, styleGuide: StyleGuide) {
        self.window = window
        self.transfersProvider = transfersProvider
        self.styleGuide = styleGuide
    }

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        showTransfers()
    }

    func close(animated: Bool, completion: (() -> Void)?) {
        assertionFailure("The close(animated:completion:) is not implemented by the AppCoordinator")
        completion?()
    }

    private func showTransfers() {
        let viewModel = TransfersViewModel(transfersProvider: transfersProvider)
        viewModel.delegate = self
        let viewController = TransfersViewController(viewModel: viewModel, styleGuide: styleGuide)
        navigationController.viewControllers = [viewController]
    }

    private func showTransfer(_ transfer: Transfer) {
        // TODO: - show Transfer screen
        /*let viewModel = TransferViewModel(transfer: transfer)
        viewModel.delegate = self
        let viewController = TransferViewController(viewModel: viewModel)
        navigationController.present(viewController, animated: true, completion: nil)*/
    }
}

extension AppCoordinator: TransfersViewModelDelegate {
    func didSelect(transfer: Transfer, from viewModel: TransfersViewModel) {
        showTransfer(transfer)
    }
}
