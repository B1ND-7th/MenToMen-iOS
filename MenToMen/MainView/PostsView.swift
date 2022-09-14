//
//  PostsView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI
import Alamofire

extension Date {
    var relative: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

struct PostsView: View {
    @Binding var navbarHidden: Bool
    @Binding var navbarUpdown: Bool
    @State var selectedFilter: Int = 5
    @State var datas = [PostDatas]()
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    let TypeDict: [String: String] = ["DESIGN": "Design",
                                      "WEB": "Web",
                                      "ANDROID": "Android",
                                      "SERVER": "Server",
                                      "IOS": "iOS"]
    func load() {
        AF.request("\(api)/post/read-all",
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
                datas = result.data
            case .failure(let error):
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    func timeParser(_ original: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: original
            .components(separatedBy: ".")[0])
        let result = date!.relative
        return result == "0초 후" ? "방금 전" : result
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
                        ZStack {
                            ZStack(alignment: .leading) {
                                VStack {
                                    HStack {
                                        Image("\(TypeDict[datas[idx].tag!] ?? "Null")BM")
                                            .resizable()
                                            .frame(width: 27, height: 39)
                                            .padding(.leading, 15)
                                        Spacer()
                                        Text("\(timeParser(datas[idx].localDateTime)) · \(datas[idx].userName)")
                                            .font(.caption)
                                            .padding(.trailing, 10)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                VStack {
                                    HStack(alignment: .top) {
                                        Text(datas[idx].content)
                                            .lineLimit(2)
                                        Spacer()
                                        AsyncImage(url: URL(string: datas[idx].imgUrl ?? "")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                        } placeholder: {
                                            Rectangle()
                                                .opacity(0)
                                                .frame(width: 40, height: 40)
                                        }
                                            .isHidden(datas[idx].imgUrl == nil, remove: true)
                                    }
                                    Spacer()
                                }
                                .padding(.top, 45)
                                .padding([.leading, .trailing], 15)
                                .padding(.bottom, 5)
                            }
                            NavigationLink(destination: PostView(data: datas[idx])
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
                        .isHidden(datas[idx].tag != TypeArray[selectedFilter].uppercased() && selectedFilter != 5, remove: true)
                    }
                }
                .customList()
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
