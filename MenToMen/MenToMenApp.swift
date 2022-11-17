//
//  MenToMenApp.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI

public let api = "http://mentomen.b1nd.com/api"
public let decoder: JSONDecoder = JSONDecoder()
public let PostDataDummy: PostDatas = PostDatas(author: 0, content: "", imgUrls: [""], createDateTime: "", updateDateTime: "", updateStatus: "", postId: 0, profileUrl: "", tag: "", userName: "", stdInfo: InfoDatas(grade: 1, room: 1, number: 1))

func exitHandler() {
    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        exit(0)
    }
}

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
