//
//  PostsView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI
import Alamofire

struct PostsView: View {
    @Binding var navbarHidden: Bool
    @Binding var navbarUpdown: Bool
    @State var selectedFilter: Int = 5
    @State var datas = [PostDatas]()
    let decoder: JSONDecoder = JSONDecoder()
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    func load() {
        AF.request("\(api)/post/readAll",
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
                guard let result = try? decoder.decode(PostData.self, from: value) else { return }
                datas = result.data
            case .failure(let error):
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                BarView(searchButton: true)
                List {
                    HStack {
                        ForEach(0..<5, id: \.self) { idx in
                            Button(action: {
                                    selectedFilter = selectedFilter == idx ? 5 : idx
                            }) {
                                ZStack {
                                    switch(selectedFilter) {
                                        case idx: Capsule()
                                            .fill(Color("\(TypeArray[idx])CR"))
                                        case 5: Capsule()
                                            .fill(Color("\(TypeArray[idx])CR"))
                                        default: Capsule()
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
                        ZStack {
                            PostsCell(data: datas[datas.count-1-idx])
                            NavigationLink(destination: PostView(data: datas[datas.count-1-idx])
                                .onAppear {
                                    navbarUpdown = true
                                    withAnimation(.default) {
                                        navbarHidden = true
                                    }
                                }
                                .onDisappear {
                                    withAnimation(.default) {
                                        navbarHidden = false
                                        navbarUpdown = false
                                    }
                                }
                            ) { }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: 0)
                                .opacity(0)
                        }
                        .customCell(true)
                        .isHidden(datas[datas.count-1-idx].tags != TypeArray[selectedFilter].uppercased() && selectedFilter != 5, remove: true)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color("M2MBackground"))
                .onAppear { load() }
                .refreshable { load() }
            }
            .navigationBarHidden(true)
            .navigationTitle("")
        }
    }
}

//struct PostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostsView()
//            //.preferredColorScheme(.dark)
//    }
//}
