//
//  Migratable.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import Foundation
protocol ImmutableConvertable: Equatable {
    associatedtype ImmutableType: ManagedConvertable
    associatedtype Context
    static func build(from immutable: ImmutableType, inContext: Context) -> Self
    func immutable() -> ImmutableType
    //    static func delete(counterpart:Counterpart, fromContext:Context) throws
}
