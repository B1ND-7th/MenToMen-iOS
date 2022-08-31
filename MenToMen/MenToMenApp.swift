//
//  MenToMenApp.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI
import KeychainAccess

public let api = "http://10.80.161.173:8080"

func saveToken(_ token: String, _ key: String) throws {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    try keychain.set(token, key: key)
}

func getToken(_ key: String) throws -> String {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    let token = try? keychain.getString(key) ?? ""
    return token!
}

func removeToken(_ key: String) throws {
    let keychain = Keychain(service: "B1ND-7th.MenToMen-iOS")
    try keychain.remove(key)
}

@main
struct MenToMenApp: App {
    var body: some Scene {
        WindowGroup {
            if (try? getToken("accessToken"))!.isEmpty {
                LoginView()
            } else { ContentView() }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove { self.hidden() }
        } else { self }
    }
}
