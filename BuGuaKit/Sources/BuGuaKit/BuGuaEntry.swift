//
//  BuGuaEntry.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-24.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public class BuGuaEntryBuilder {
    var name = "姓名"
    var question = "想問"
    var date: GregorianDate = .zero
    var time: GregorianTime = .zero
    var notes = "沒有筆記"
    var guaXiang: LiuYaoGuaXiang = .default

    public init() {}

    @discardableResult
    public func setName(_ value: String) -> BuGuaEntryBuilder {
        name = value
        return self
    }

    @discardableResult
    public func setQuestion(_ value: String) -> BuGuaEntryBuilder {
        question = value
        return self
    }

    @discardableResult
    public func setDate(_ value: GregorianDate) -> BuGuaEntryBuilder {
        date = value
        return self
    }

    @discardableResult
    public func setTime(_ value: GregorianTime) -> BuGuaEntryBuilder {
        time = value
        return self
    }

    @discardableResult
    public func setNotes(_ value: String) -> BuGuaEntryBuilder {
        notes = value
        return self
    }

    @discardableResult
    public func setGuaXiang(_ value: LiuYaoGuaXiang) -> BuGuaEntryBuilder {
        guaXiang = value
        return self
    }

    public func build() -> BuGuaEntry {
        return BuGuaEntry(name: name, question: question, date: date, time: time, notes: notes, guaXiang: guaXiang)
    }
}

public struct BuGuaEntry: Equatable {
    public let name: String
    public let question: String
    public let date: GregorianDate
    public let time: GregorianTime
    public let notes: String
    public let guaXiang: LiuYaoGuaXiang

    public static let `default` = BuGuaEntryBuilder().build()
}
