//
//  NotifyView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import Alamofire
import CachedAsyncImage

struct NotifyView: View {
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    @State var datas: [NotifyDatas] = [NotifyDatas]()
    func load() {
        AF.request("\(api)/notice/list",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 10 }
        .validate()
        .responseData { response in
            checkResponse(response)
            switch response.result {
            case .success:
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(NotifyData.self, from: value) else { return }
                datas = result.data
            case .failure(let error):
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(0..<datas.count, id: \.self) { idx in
                    HStack {
                        CachedAsyncImage(url: URL(string: datas[idx].senderProfileImage ?? "")) { image in
                            image
                                .resizable()
                        } placeholder: {
                            if datas[idx].senderProfileImage == nil {
                                Image("profile")
                                    .resizable()
                            } else {
                                NothingView()
                            }
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        VStack {
                            Text("**\(datas[idx].senderName)**님이 회원님의 게시글에 답글을 남겼습니다.")
                            Text("\"\(datas[idx].commentContent)\"")
                        }
                    }
                    .customCell()
                }
            }
            .padding(.top, 61)
            .customList()
            .refreshable {
                load()
            }
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
        .onAppear {
            load()
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
