//
//  ProfileView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/26.
//

import SwiftUI
import Alamofire
import CachedAsyncImage

struct ProfileView: View {
    @Binding var logout: Bool
    @Binding var postdata: PostDatas
    @Binding var postlink: Bool
    @Binding var postuser: Int
    @Binding var refresh: Bool
    @State var name: String = ""
    @State var profileImage: String = "null"
    @State var info: String = ""
    @State var email: String = ""
    @State var datas = [PostDatas]()
    @State var userId: Int = 0
    func load() {
        AF.request("\(api)/user/my",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 5 }
        .validate()
        .responseData { response in
            checkResponse(response)
            switch response.result {
            case .success:
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(ProfileData.self, from: value) else { return }
                let data = result.data
                name = data.name
                profileImage = data.profileImage ?? ""
                info = "\(data.stdInfo.grade)학년 \(data.stdInfo.room)반 \(data.stdInfo.number)번"
                email = data.email
                userId = data.userId
                AF.request("\(api)/user/post",
                           method: .get,
                           encoding: URLEncoding.default,
                           headers: ["Content-Type": "application/json"],
                           interceptor: Requester()
                ) { $0.timeoutInterval = 10 }
                .validate()
                .responseData { response in
                    checkResponse(response)
                    print(checkStatus(response))
                    switch response.result {
                    case .success:
                        guard let value = response.value else { return }
                        guard let result = try? decoder.decode(PostsData.self, from: value) else { return }
                        withAnimation(.default) {
                            datas = result.data
                        }
                    case .failure(let error):
                        print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                    }
                }
            case .failure(let error):
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        HStack {
                            CachedAsyncImage(url: URL(string: profileImage)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                switch profileImage.count {
                                case 0: Image("profile")
                                        .resizable()
                                default: NothingView()
                                }
                            }
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(info)
                                Text("\(name)님, 환영합니다!")
                                    .fontWeight(.bold)
                                    .font(.title2)
                                Text(email)
                                    .fontWeight(.light)
                            }
                            Spacer()
                        }
                        .padding()
                        Rectangle()
                            .fill(Color("M2MBackground"))
                            .frame(height: 1)
                        Button(action: {
                            try! removeToken("accessToken")
                            try! removeToken("refreshToken")
                            logout.toggle()
                        }) {
                            Text("로그아웃")
                                .foregroundColor(.red)
                                .padding(.leading, 20)
                                .setAlignment(for: .leading)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                    }
                    .customCell()
                    .padding(.bottom, 14)
                    ForEach(0..<datas.count, id: \.self) { idx in
                        Button(action: {
                            postdata = datas[idx]
                            postuser = userId
                            postlink = true
                        }) {
                            PostsCell(data: $datas[idx])
                        }
                        .customCell(true, decrease: idx == 0)
                        .padding(.bottom, datas.count == idx+1 ? bottomPadding + 20 : 0)
                    }
                }
                .customList()
                .onAppear { load() }
                .refreshable { load() }
                .onChange(of: refresh) { state in
                    load()
                    refresh = false
                }
            }
            .navigationBarHidden(true)
            .navigationTitle("")
        }
    }
}
