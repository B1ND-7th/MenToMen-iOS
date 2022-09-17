//
//  MenToMenApp.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI

public let api = "http://10.80.162.51:8080"
public let decoder: JSONDecoder = JSONDecoder()

@main
struct MenToMenApp: App {
    var body: some Scene {
        WindowGroup {
            if (try? getToken("accessToken"))!.isEmpty {
                LoginView()
            } else { MainView() }
        }
    }
}
