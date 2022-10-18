//
//  PostsView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI
import Alamofire

struct PostsView: View {
    @Binding var postdata: PostDatas
    @Binding var postlink: Bool
    @Binding var postuser: Int
    @Binding var searchText: String
    @Binding var refresh: Bool
    @State var errorToggle: Bool = false
    @State var selectedFilter: Int = 5
    @State var originalDatas = [PostDatas]()
    @State var datas = [PostDatas]()
    @State var userId: Int = 0
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    func dataSearch() {
        withAnimation(.default) {
            if searchText.isEmpty {
                datas = originalDatas
            } else {
                datas = originalDatas.filter {
                    $0.content.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    func load() {
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
                userId = result.data.userId
                AF.request("\(api)/post/read-all",
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
                        guard let result = try? decoder.decode(PostsData.self, from: value) else { return }
                        originalDatas = result.data
                        dataSearch()
                    case .failure(let error):
                        errorToggle.toggle()
                        print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                    }
                }
            case .failure(let error):
                errorToggle.toggle()
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    HStack {
                        ForEach(0..<5, id: \.self) { idx in
                            Button(action: {
                                withAnimation(.default) {
                                    selectedFilter = selectedFilter == idx ? 5 : idx
                                }
                            }) {
                                ZStack {
                                    Capsule()
                                        .fill(selectedFilter == idx || selectedFilter == 5 ? Color("\(TypeArray[idx])CR") : .gray)
                                    Text(TypeArray[idx])
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 25)
                            }
                        }
                    }
                    .customShadow(2)
                    .padding(.top, 15)
                    .padding(.bottom, 8)
                    .padding([.leading, .trailing], 20)
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                    .background(Color("M2MBackground"))
                    ForEach(0..<datas.count, id: \.self) { idx in
                        if datas[idx].tag == TypeArray[selectedFilter].uppercased() || selectedFilter == 5 {
                            Button(action: {
                                postdata = datas[idx]
                                postuser = userId
                                postlink = true
                            }) {
                                PostsCell(data: $datas[idx])
                            }
                            .customCell(true, decrease: true)
                            .padding(.bottom, datas.count == idx+1 ? bottomPadding + 25 : 0)
                        }
                    }
                }
                .customList()
                .onAppear { load() }
                .refreshable { load() }
                .onChange(of: refresh) { state in
                    load()
                    refresh = false
                }
                .onChange(of: searchText) { text in
                    dataSearch()
                }
            }
            .exitAlert($errorToggle)
            .navigationBarHidden(true)
            .navigationTitle("")
        }
    }
}
