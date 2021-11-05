//
//  Formatter+Currency.swift
//  CryptoTracker
//
//  Created by Gabriela Sillis on 04/11/21.
//

import Foundation

extension Locale {
    static let usLocale = Locale(identifier: "en_US")
    static let brLocale = Locale(identifier: "pt_BR")
}

extension NumberFormatter {
    convenience init(style: Style, locale: Locale = .current) {
        self.init()
        numberStyle = style
        self.locale = locale
        formatterBehavior = .default
    }
}

extension Double {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter(style: .currency, locale: .usLocale)
        formatter.allowsFloats = true
        formatter.maximumFractionDigits = 2

        return formatter
    }()

    var currency: String {
        Double.currencyFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
