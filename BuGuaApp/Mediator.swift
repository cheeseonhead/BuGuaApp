//
//  Mediator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

/// Mediators associate usually with one instance of ManagedObject. It's responsible for taking in an immutable version
/// of that object and saving its changes.
protocol Mediator {
    associatedtype ManagedObject: ImmutableConvertable

    init(immutable: ManagedObject.ImmutableType, storageManager: StorageManager)
    init(object: ManagedObject, storageManager: StorageManager)
    var input: PublishRelay<ManagedObject.ImmutableType> { get }
    var output: Driver<ManagedObject.ImmutableType> { get }
}
