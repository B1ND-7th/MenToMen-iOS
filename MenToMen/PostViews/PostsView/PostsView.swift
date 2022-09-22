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
    @FocusState var searchState: Bool
    @State var searchToggle: Bool = false
    @State var searchText: String = ""
    @State var errorToggle: Bool = false
    @State var selectedFilter: Int = 5
    @State var originalDatas = [PostDatas]()
    @State var datas = [PostDatas]()
    @State var userId: Int = 0
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    func dataSearch() {
        if searchText.isEmpty {
            datas = originalDatas
        } else {
            datas = originalDatas.filter {
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    func load() {
        AF.request("\(api)/user/my",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 10 }
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
                ) { $0.timeoutInterval = 10 }
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
                HStack(spacing: 15) {
                    if searchToggle {
                        TextField("검색어를 입력해주세요", text: $searchText)
                            .focused($searchState)
                            .font(.title3)
                            .frame(height: 33.8)
                            .onChange(of: searchText) { text in
                                withAnimation(.default) {
                                    dataSearch()
                                }
                            }
                    } else {
                        Image("M2MLogo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(.label))
                            .frame(width: 100, height: 33.8)
                        Spacer()
                    }
                    Button(action: {
                        withAnimation(.default) {
                            if !searchToggle || searchText.isEmpty {
                                searchToggle.toggle()
                                searchState.toggle()
                            } else {
                                searchState = false
                            }
                        }
                    }) {
                        Image("search-normal")
                            .renderIcon()
                    }
                    .frame(width: 25, height: 25)
                    if !searchToggle {
                        NavigationLink(destination: NotifyView()) {
                            ZStack {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .position(x: 22, y: 0)
                                Image("notification")
                                    .renderIcon()
                            }
                        }
                        .frame(width: 25, height: 25)
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 16)
                .padding(.top, 12)
                .background(Color(.secondarySystemGroupedBackground))
                List {
                    HStack {
                        ForEach(0..<5, id: \.self) { idx in
                            Button(action: {
                                withAnimation(.default) {
                                    selectedFilter = selectedFilter == idx ? 5 : idx
                                }
                            }) {
                                ZStack {
                                    if selectedFilter == idx || selectedFilter == 5 {
                                        Capsule()
                                            .fill(Color("\(TypeArray[idx])CR"))
                                    } else {
                                        Capsule()
                                            .strokeBorder(Color("\(TypeArray[idx])CR"), lineWidth: 1)
                                    }
                                    Text(TypeArray[idx])
                                        .font(.caption)
                                        .foregroundColor(selectedFilter == idx || selectedFilter == 5 ? .white : Color("\(TypeArray[idx])CR"))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 25)
                            }
                        }
                    }
                    .padding([.top, .bottom], 15)
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
                            .customCell(true)
                        }
                    }
                }
                .customList()
                .onAppear { load() }
                .refreshable { load() }
            }
            .exitAlert($errorToggle)
            .navigationBarHidden(true)
            .navigationTitle("")
        }
    }
}
