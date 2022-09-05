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
                HStack(spacing: 15) {
                    Image("M2MLogo")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.label))
                        .frame(width: 100, height: 33.8)
                    Spacer()
                    Button(action: { }) {
                        Image("search-normal")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(.label))
                    }
                    .frame(width: 25, height: 25)
                    NavigationLink(destination: NotifyView()) {
                        ZStack {
                            Circle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                                .position(x: 22, y: 0)
                            Image("notification")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color(.label))
                        }
                    }
                    .frame(width: 25, height: 25)
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 16)
                .padding(.top, 12)
                .background(Color(.secondarySystemGroupedBackground))
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
                            PostsCell(data: datas[idx])
                            NavigationLink(destination: PostView()
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
                                .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 100)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .padding([.bottom, .leading, .trailing], 20)
                        .listRowInsets(EdgeInsets())
                        .background(Color("M2MBackground"))
                        .isHidden(datas[idx].tags != TypeArray[selectedFilter].uppercased() && selectedFilter != 5, remove: true)
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
