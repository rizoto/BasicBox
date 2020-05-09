//
//  TokenManager.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 8/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import KeychainAccess

struct TokenManager {
    func saveTokens(demoToken: String, liveToken: String) {
        let keychainDemo = Keychain(service: "au.com.itroja.oanda.demo", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        keychainDemo["demoToken"] = demoToken
        let keychainLive = Keychain(service: "au.com.itroja.oanda.live", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        keychainLive["liveToken"] = liveToken
    }
    func saveAccounts(demoAccount: String, liveAccount: String) {
        let keychainDemo = Keychain(service: "au.com.itroja.oanda.demo", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        keychainDemo["demoAccount"] = demoAccount
        let keychainLive = Keychain(service: "au.com.itroja.oanda.live", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        keychainLive["liveAccount"] = liveAccount
    }
    func fetchTokens() -> (String, String) {
        var demoToken: String
        var liveToken: String
        let keychainDemo = Keychain(service: "au.com.itroja.oanda.demo", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        demoToken = keychainDemo["demoToken"] ?? ""
        let keychainLive = Keychain(service: "au.com.itroja.oanda.live", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        liveToken = keychainLive["liveToken"] ?? ""
        return (demoToken, liveToken)
    }
    func fetchAccounts() -> (String, String) {
        var demoAccount: String
        var liveAccount: String
        let keychainDemo = Keychain(service: "au.com.itroja.oanda.demo", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        demoAccount = keychainDemo["demoAccount"] ?? ""
        let keychainLive = Keychain(service: "au.com.itroja.oanda.live", accessGroup: "$(AppIdentifierPrefix)au.com.itroja.OandaTokensShared")
        liveAccount = keychainLive["liveAccount"] ?? ""
        return (demoAccount, liveAccount)
    }
}
