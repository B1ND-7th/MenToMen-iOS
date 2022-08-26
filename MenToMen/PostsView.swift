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
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                HStack {
                    Image("\(data.type)BM")
                        .resizable()
                        .frame(width: 27, height: 39)
                        .padding(.leading, 15)
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
            .padding(.top, 45)
            .padding([.leading, .trailing], 15)
            .padding(.bottom, 5)
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 100)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .padding([.bottom, .leading, .trailing], 20)
        .listRowInsets(EdgeInsets())
        .background(Color(.systemGroupedBackground))
    }
}

struct PostsView: View {
    let TypeArray = ["Design", "Web", "Android", "Server", "iOS"]
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
                    type: "Android"
                 ),
        PostTypes(title: "iOS 코드베이스 하실 줄 아는 분 구해요",
                    name: "조상영",
                    grade: "1215",
                    time: "30분 전",
                    type: "Server"
                 )
    ]
    var body: some View {
        VStack {
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
                Button(action: { }) {
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
            .padding(.bottom, 6)
            .padding(.top, 12)
            List {
                HStack {
                    ForEach(0..<5, id: \.self) { idx in
                        Button(action: { }) {
                            Text(TypeArray[idx])
                                .font(.caption)
                                .frame(width: 63, height: 25)
                                .foregroundColor(.white)
                                .background(Color("\(TypeArray[idx])CR"))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding([.top, .bottom], 15)
                .buttonStyle(PlainButtonStyle())
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets())
                .background(Color(.systemGroupedBackground))
                .listRowBackground(Color(.systemGroupedBackground))
                ForEach(0..<postTypeArray.count, id: \.self) { idx in
                    PostsCellView(data: postTypeArray[idx])
                }
            }
            .listStyle(PlainListStyle())
            .background(Color("M2MBackground"))
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
            //.preferredColorScheme(.dark)
    }
}
