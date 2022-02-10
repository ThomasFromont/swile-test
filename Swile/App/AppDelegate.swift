//
//  AppDelegate.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator(
            window: window,
            transactionsRepository: TransactionsRepository(),
            dateFormatter: Swile.DateFormatter(),
            priceFormatter: PriceFormatter(),
            styleGuide: StyleGuide.shared
        )
        coordinator?.start()

        return true
    }
}
