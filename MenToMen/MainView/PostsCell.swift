//
//  PostsCell.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI

struct PostsCell: View {
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
                    Text("\(data.name) · \(data.date)")
                        .font(.caption)
                        .padding(.trailing, 10)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            VStack {
                HStack {
                    Text(data.title)
                    Spacer()
                    AsyncImage(url: URL(string: data.thumb)) { image in
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
                        .isHidden(data.thumb.isEmpty, remove: true)
                }
                Spacer()
            }
            .padding(.top, 45)
            .padding([.leading, .trailing], 15)
            .padding(.bottom, 5)
        }
    }
}
