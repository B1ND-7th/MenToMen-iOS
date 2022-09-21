//
//  PostsCell.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI

struct PostsCell: View {
    @Binding var data: PostDatas
    let TypeDict: [String: String] = ["DESIGN": "Design",
                                      "WEB": "Web",
                                      "ANDROID": "Android",
                                      "SERVER": "Server",
                                      "IOS": "iOS"]
    func timeParser(_ original: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: original
            .components(separatedBy: ".")[0])
        let result = date!.relative
        return result == "0초 후" ? "방금 전" : result
    }
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                HStack {
                    Image("\(TypeDict[data.tag!] ?? "Null")BM")
                        .resizable()
                        .frame(width: 27, height: 39)
                        .padding(.leading, 15)
                    Spacer()
                    Text("""
                         \(timeParser(data.createDateTime))\
                         \(data.updateStatus == "UPDATE" ? "(수정됨)" : "") \
                         · \(data.userName)
                         """)
                        .font(.caption)
                        .padding(.trailing, 10)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            VStack {
                HStack(alignment: .top) {
                    Text(data.content)
                        .lineLimit(2)
                    Spacer()
                    AsyncImage(url: URL(string: data.imgUrl ?? "")) { image in
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
                    .isHidden(data.imgUrl == nil, remove: true)
                }
                Spacer()
            }
            .padding(.top, 45)
            .padding([.leading, .trailing], 15)
            .padding(.bottom, 5)
        }
    }
}
