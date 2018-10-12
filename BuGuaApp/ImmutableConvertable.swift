//
//  ImmutableConvertable.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import Foundation

/// Objects conforming to this protocol are saying they can be converted into an immutable version of itself and vice
/// versa.
protocol ImmutableConvertable: Equatable {
    associatedtype ImmutableType: ManagedConvertable
    associatedtype Context

    static func build(from immutable: ImmutableType, inContext: Context) -> Self
    func immutable() -> ImmutableType
    func update(with immutable: ImmutableType)
}
