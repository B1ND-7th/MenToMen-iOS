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
    @Binding var refresh: Bool
    @State var datas: [NotifyDatas] = [NotifyDatas]()
    @State var postlink: Bool = false
    @State var postdata: PostDatas = PostDataDummy
    @State var postuser: Int = 0
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
                    NavigationLink(destination: PostView(refresh: $refresh, data: postdata, userId: postuser)
                        .navigationBarHidden(true), isActive: $postlink) { EmptyView() }
                    Button(action: {
                        AF.request("\(api)/user/my",
                                   method: .get,
                                   encoding: URLEncoding.default,
                                   headers: ["Content-Type": "application/json"],
                                   interceptor: Requester()
                        ) { $0.timeoutInterval = 5 }
                        .validate()
                        .responseData { response in
                            switch response.result {
                            case .success:
                                guard let value = response.value else { return }
                                guard let result = try? decoder.decode(ProfileData.self, from: value) else { return }
                                postuser = result.data.userId
                                AF.request("\(api)/post/read-one/\(datas[idx].postId)",
                                           method: .get,
                                           encoding: URLEncoding.default,
                                           headers: ["Content-Type": "application/json"],
                                           interceptor: Requester()
                                ) { $0.timeoutInterval = 5 }
                                .validate()
                                .responseData { response in
                                    checkResponse(response)
                                    print(checkStatus(response))
                                    switch response.result {
                                    case .success:
                                        guard let value = response.value else { return }
                                        guard let result = try? decoder.decode(PostData.self, from: value) else { return }
                                        postdata = result.data
                                        postlink.toggle()
                                    case .failure(let error):
                                        print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                                    }
                                }
                            case .failure(let error):
                                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                            }
                        }
                    }){
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
                            VStack(alignment: .leading) {
                                Text(.init("**\(datas[idx].senderName)**님이 답글을 남겼습니다."))
                                Text("\"\(datas[idx].commentContent)\"")
                                    .lineLimit(2)
                            }
                            .foregroundColor(Color(.label))
                            .setAlignment(for: .leading)
                        }
                        .padding()
                        .customCell(true)
                    }
                }
                .padding(.top, 21)
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
