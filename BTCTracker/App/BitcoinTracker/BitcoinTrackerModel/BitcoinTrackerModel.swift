//
//  BitcoinTrackerModel.swift
//  BTCTracker
//
//  Created by Sachin Ambegave on 21/10/21.
//

import Foundation

// MARK: - BitcoinTrackerModel
class BitcoinTrackerModel: Codable {
    var time: Time?
    var disclaimer, chartName: String?
    var bpi: Bpi?

    init(time: Time?, disclaimer: String?, chartName: String?, bpi: Bpi?) {
        self.time = time
        self.disclaimer = disclaimer
        self.chartName = chartName
        self.bpi = bpi
    }
}

// MARK: - Bpi
class Bpi: Codable {
    var usd, gbp, eur: Eur?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }

    init(usd: Eur?, gbp: Eur?, eur: Eur?) {
        self.usd = usd
        self.gbp = gbp
        self.eur = eur
    }
}

// MARK: - Eur
class Eur: Codable {
    var code, symbol, rate, eurDescription: String?
    var rateFloat: Double?

    enum CodingKeys: String, CodingKey {
        case code, symbol, rate
        case eurDescription = "description"
        case rateFloat = "rate_float"
    }

    init(code: String?, symbol: String?, rate: String?, eurDescription: String?, rateFloat: Double?) {
        self.code = code
        self.symbol = symbol
        self.rate = rate
        self.eurDescription = eurDescription
        self.rateFloat = rateFloat
    }
}

// MARK: - Currency
class Currency: Codable {
    var name: String?
    var value: Eur?

    init(name: String?, value: Eur?) {
        self.name = name
        self.value = value
    }
}

// MARK: - Time
class Time: Codable {
    var updated: String?
    var updatedISO: String?
    var updateduk: String?

    init(updated: String?, updatedISO: String?, updateduk: String?) {
        self.updated = updated
        self.updatedISO = updatedISO
        self.updateduk = updateduk
    }
}
