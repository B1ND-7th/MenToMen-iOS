//
//  Keychain.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/15.
//

import KeychainAccess

let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")

func saveToken(_ token: String, _ key: String) throws {
    try keychain.set(token, key: key)
}

func getToken(_ key: String) throws -> String {
    let token = try? keychain.getString(key) ?? ""
    return token!
}

func removeToken(_ key: String) throws {
    try keychain.remove(key)
}
