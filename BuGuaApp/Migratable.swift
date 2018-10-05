//
//  Migratable.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

protocol ImmutableConvertable: Equatable {
    associatedtype ImmutableType
    associatedtype Context

    init(immutable: ImmutableType)

    func immutable() -> ImmutableType
    //    static func delete(counterpart:Counterpart, fromContext:Context) throws
}
