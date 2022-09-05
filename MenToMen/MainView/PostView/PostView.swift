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
        VStack {
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
            ScrollView {
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
