//
//  MenToMenApp.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI

public let api = "http://10.80.162.9:8080"

@main
struct MenToMenApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
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
