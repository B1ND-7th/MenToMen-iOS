//
//  PostsView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI

struct PostTypes {
    let title: String
    let name: String
    let grade: String
    let time: String
    let type: String
}

struct PostsCellView: View {
    let data: PostTypes
    let autoColor: [String: [Color]] = ["iOS": [Color(.systemBackground), Color(.label)],
                                        "Android": [.black, Color("Android")],
                                        "Web": [],
                                        "Server": [],
                                        "Design": [.white, Color("Design")]
                                        ]
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                HStack {
                    Text(data.type)
                        .frame(width: 90, height: 30)
                        .foregroundColor(autoColor[data.type]![0])
                        .background(autoColor[data.type]![1])
                        .cornerRadius(50, corners: [.topLeft, .bottomRight])
                    Spacer()
                    Text("\(data.grade) \(data.name)")
                        .font(.caption)
                        .padding(.trailing, 10)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            VStack {
                Text(data.title)
                Spacer()
            }
            .padding(.top, 40)
            .padding([.leading, .trailing], 15)
            .padding(.bottom, 5)
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 95)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .padding([.top, .leading, .trailing], 20)
        .listRowInsets(EdgeInsets())
        .background(Color(.systemGroupedBackground))
    }
}

struct PostsView: View {
    let postTypeArray: [PostTypes] = [
        PostTypes(title: "나르샤 iOS 대신 만들어주실 분 구해요~~ 상은선배님이면 좋아용 ㅎㅎ",
                    name: "조상영",
                    grade: "1215",
                    time: "1분 전",
                    type: "iOS"
                 ),
        PostTypes(title: "김종윤한테 디자인알려줄 선배님 구해요 급하지는 않아요 ㅎㅎㅎ + 서버",
                    name: "조상영",
                    grade: "1215",
                    time: "12분 전",
                    type: "Design"
                 ),
        PostTypes(title: "SwiftUI StackView 사용할 줄 아는 멘토님 + 서버 구해요 ㅠㅠㅠ(급함",
                    name: "조상영",
                    grade: "1215",
                    time: "18분 전",
                    type: "iOS"
                 ),
        PostTypes(title: "iOS 코드베이스 하실 줄 아는 분 구해요",
                    name: "조상영",
                    grade: "1215",
                    time: "30분 전",
                    type: "Android"
                 )
    ]
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Text("대충 아무 로고")
                    .font(.title3)
                    .bold()
                Spacer()
                Button(action: { }) {
                    Image("search-normal")
                        .resizable()
                }
                .frame(width: 25, height: 25)
                Button(action: { }) {
                    ZStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                            .position(x: 22, y: 0)
                        Image("notification")
                            .resizable()
                    }
                }
                .frame(width: 25, height: 25)
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 6)
            List(0..<postTypeArray.count, id: \.self) { idx in
                PostsCellView(data: postTypeArray[idx])
            }
            .listStyle(PlainListStyle())
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
            //.preferredColorScheme(.dark)
    }
}
