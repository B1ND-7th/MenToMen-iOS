//
//  PostsCell.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import CachedAsyncImage

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
                HStack(alignment: .top) {
                    Image("\(TypeDict[data.tag!] ?? "Null")BM")
                        .resizable()
                        .frame(width: 27, height: 39)
                        .padding(.leading, 15)
                    VStack(alignment: .leading) {
                        Text(data.userName)
                            .foregroundColor(Color(.label))
                        Text("\(data.stdInfo.grade)학년 \(data.stdInfo.room)반 \(data.stdInfo.number)번")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 6)
                    Spacer()
                    Text("""
                         \(timeParser(data.createDateTime))\
                         \(data.updateStatus == "UPDATE" ? "(수정됨)" : "")
                         """)
                        .padding([.top, .trailing], 10)
                        .foregroundColor(.gray)
                }
                .font(.caption)
                Spacer()
            }
            VStack {
                HStack(alignment: .top) {
                    Text(data.content)
                        .foregroundColor(Color(.label))
                        .multilineTextAlignment(.leading)
                        .lineLimit(7)
                    Spacer()
                    if data.imgUrls != nil {
                        CachedAsyncImage(url: URL(string: data.imgUrls?[0] ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            NothingView()
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                Spacer()
            }
            .padding(.top, 45)
            .padding([.leading, .trailing], 15)
            .padding(.bottom, 5)
        }
    }
}
