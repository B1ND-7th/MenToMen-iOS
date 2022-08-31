//
//  PostsView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI

struct PostsView: View {
    @State var selectedFilter: Int = 5
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    let postTypeArray: [PostTypes] = [
        PostTypes(title: "나르샤 iOS 대신 만들어주실 분 구해요~~ 상은선배님이면 좋아용 ㅎㅎ",
                    name: "이민규",
                    date: "8월 26일",
                    time: "1분 전",
                    type: "iOS",
                    thumb: "http://nater.com/nater_riding.jpg"
                 ),
        PostTypes(title: "김종윤한테 디자인알려줄 선배님 구해요 급하지는 않아요 ㅎㅎㅎ + 서버",
                    name: "김종윤",
                    date: "8월 26일",
                    time: "12분 전",
                    type: "Server",
                    thumb: ""
                 ),
        PostTypes(title: "바닐라 JS 도와주실 선배님 찾습니다ㅠㅠ 급합니다",
                    name: "조상영",
                    date: "8월 26일",
                    time: "18분 전",
                    type: "Web",
                    thumb: ""
                 ),
        PostTypes(title: "안드로이드 한번 배워보고 싶은데 첫 걸음을 도와주실 선배님을 구합니다.",
                    name: "이석호",
                    date: "8월 26일",
                    time: "30분 전",
                    type: "Android",
                    thumb: ""
                 ),
        PostTypes(title: "피그마나 일러스트레이터 알려주실분 급구합니다 우리 사이트 디자인 망했어요",
                    name: "배경민",
                    date: "8월 26일",
                    time: "35분 전",
                    type: "Design",
                    thumb: ""
                 ),
        PostTypes(title: "자프링이나 코프링 시작해보려고 하는데 너무 어려워요 도움이 필요합니다",
                    name: "강지석",
                    date: "8월 26일",
                    time: "37분 전",
                    type: "Server",
                    thumb: ""
                 ),
        PostTypes(title: "안뇽~",
                    name: "이재건",
                    date: "8월 26일",
                    time: "40분 전",
                    type: "Web",
                    thumb: ""
                 ),
        PostTypes(title: "플러터에서 안드로 넘어왔는데 이 오류 때문에 막혀서 못하겠어요ㅠㅠ",
                    name: "조승완",
                    date: "8월 26일",
                    time: "42분 전",
                    type: "Android",
                    thumb: ""
                 ),
        PostTypes(title: "임베에서 iOS입문한 초보입니다 SwiftUI 하시는 선배님 있으면 연락주세요",
                    name: "황주완",
                    date: "8월 26일",
                    time: "50분 전",
                    type: "iOS",
                    thumb: ""
                 ),
        PostTypes(title: "디자인 좀 도와주실 분 구합니다! 나르샤 프로젝트에요!! 급함",
                    name: "윤석규",
                    date: "8월 26일",
                    time: "56분 전",
                    type: "Design",
                    thumb: ""
                 )
    ]
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
                    ForEach(0..<postTypeArray.count, id: \.self) { idx in
                        ZStack {
                            PostsCell(data: postTypeArray[idx])
                            NavigationLink(destination: PostView()) { }
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
                        .isHidden(postTypeArray[idx].type != TypeArray[selectedFilter] && selectedFilter != 5, remove: true)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color("M2MBackground"))
                .refreshable {
                    
                }
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
