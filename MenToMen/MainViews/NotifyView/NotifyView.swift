//
//  NotifyView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import CachedAsyncImage

struct NotifyView: View {
    let profileUrl: String? = "http://dodam.b1nd.com/api/image/png/DW_IMG_89280208781.png"
    let name: String = "이석호"
    var body: some View {
        ScrollView {
            HStack {
                CachedAsyncImage(url: URL(string: profileUrl ?? "")) { image in
                    image
                        .resizable()
                } placeholder: {
                    if profileUrl == nil {
                        Image("profile")
                            .resizable()
                    } else {
                        NothingView()
                    }
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                VStack {
                    Text("**김종윤**님이 회원님의 게시글에 답글을 남겼습니다.")
                    Text("\"엄준식은 살아있다!!!!\"")
                }
            }
            .customCell()
        }
        .customList()
    }
}

struct NotifyView_Previews: PreviewProvider {
    static var previews: some View {
        NotifyView()
    }
}
