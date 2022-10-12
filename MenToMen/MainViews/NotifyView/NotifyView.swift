//
//  NotifyView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import CachedAsyncImage

struct NotifyView: View {
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    let profileUrl: String? = "http://dodam.b1nd.com/api/image/png/DW_IMG_89280208781.png"
    let name: String = "이석호"
    var body: some View {
        ZStack {
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
                        Text("**\(name)**님이 회원님의 게시글에 답글을 남겼습니다.")
                        Text("\"엄준식은 살아있다!!!!\"")
                    }
                }
                .customCell()
                .padding(.top, 61)
            }
            .customList()
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("back")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.label))
                }
                .frame(width: 30, height: 30)
                .padding(.leading, 10)
                Spacer()
                Text("알림")
                    .padding(.trailing, 40)
                Spacer()
            }
            .padding(.top, topPadding)
            .frame(height: topPadding + 61)
            .background(Color(.secondarySystemGroupedBackground))
            .setAlignment(for: .top)
            .customShadow()
            .edgesIgnoringSafeArea(.top)
        }
        .dragGesture(dismiss, $dragOffset)
        .navigationBarHidden(true)
    }
}

struct NotifyView_Previews: PreviewProvider {
    static var previews: some View {
        NotifyView()
    }
}
