//
//  PersonView.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/28.
//

import SwiftUI
import CachedAsyncImage

struct PersonView: View {
    @Binding var writeToggles: Bool
    @Binding var deleteAlert: Bool
    let profileUrl: String?
    let userName: String
    let stdInfo: InfoDatas
    let author: Int
    let userId: Int
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: profileUrl ?? "")) { image in
                image
                    .resizable()
            } placeholder: {
                if profileUrl == nil {
                    Image("profile")
                        .resizable()
                } else {
                    NothingView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(userName)
                Text("\(stdInfo.grade)학년 \(stdInfo.room)반 \(stdInfo.number)번")
                    .foregroundColor(.gray)
            }
            Spacer()
            if author == userId {
                Button(action: {
                    writeToggles.toggle()
                }) {
                    Image("write")
                        .renderIcon()
                }
                .frame(width: 25, height: 25)
                Button(action: {
                    deleteAlert.toggle()
                }) {
                    Image("trash")
                        .renderIcon()
                }
                .frame(width: 25, height: 25)
                .padding([.leading, .trailing], 5)
            }
        }
        .padding(.bottom, 10)
    }
}
