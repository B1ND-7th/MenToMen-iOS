//
//  PostView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("back")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.label))
                }
                .frame(width: 30, height: 30)
                .padding(.leading, 10)
                Spacer()
            }
            .frame(height: 61)
            List {
                VStack {
                    Text("안뇽")
                }
                .buttonStyle(PlainButtonStyle())
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 100)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(15)
                .padding([.top, .leading, .trailing], 20)
                .listRowInsets(EdgeInsets())
                .background(Color("M2MBackground"))
            }
            .listStyle(PlainListStyle())
            .background(Color("M2MBackground"))
        }
        .navigationBarHidden(true)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
