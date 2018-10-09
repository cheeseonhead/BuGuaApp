//
//  AppFactory.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import CloudKit
import CoreData
import Foundation
import UIKit

class AppFactory {
    let timeZone = TimeZone.autoupdatingCurrent
    let themeStore = ShallowThemeStore(initialTheme: .light)

    // MARK: - Managers

    let themeManager: ThemeManager
    let storageManager: StorageManager
    let cacheManager: CacheManager
    let cloudManager: CloudKitManager

    // MARK: - CoreData

    let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container

        themeManager = ThemeManager(store: themeStore)

        let cacheContext = container.newBackgroundContext()
        cacheManager = CacheManager(context: cacheContext, dateGenerator: { Date() as NSDate })

        storageManager = StorageManager(cacheManager: cacheManager, context: container.viewContext)

        cloudManager = CloudKitManager(container: CKContainer.default(), zone: CKRecordZone(zoneName: "Test"), cacheManager: cacheManager)
    }

    func makeAppCoordinator(with window: UIWindow) -> AppCoordinator {
        return AppCoordinator(with: window, factory: self)
    }

    func makeBuGuaEntryCoordinator() -> BuGuaEntryCoordinator {
        return BuGuaEntryCoordinator(factory: self)
    }

    func makeGuaXiangViewController(viewModel: GuaXiangViewModel) -> GuaXiangViewController {
        return GuaXiangViewController(viewModel: viewModel)
    }

    func makeSolarTermCalculator() throws -> SolarTermCalculator {
        return try SolarTermCalculator.make()
    }

    func makeGregorianFormatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> GregorianFormatter {
        return GregorianFormatter(calendar: Calendar.autoupdatingCurrent, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}
