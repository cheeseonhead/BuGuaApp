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
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    let storageManager: StorageManager
    let cloudManager: CloudKitManager
    let timeZone = TimeZone.autoupdatingCurrent
    let themeStore = ShallowThemeStore(initialTheme: .light)
    let themeManager: ThemeManager

    init(container: NSPersistentContainer, context: NSManagedObjectContext) {
        themeManager = ThemeManager(store: themeStore)
        self.container = container
        self.context = context

        let uploadContext = container.newBackgroundContext()

        cloudManager = CloudKitManager(container: CKContainer.default(), zone: CKRecordZone(zoneName: "Test"), context: uploadContext)
        self.storageManager = StorageManager(container: container, context: context, cloudManager: cloudManager)
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
