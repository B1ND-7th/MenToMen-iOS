//
//  WriteView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/26.
//

import SwiftUI

struct WriteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var text: String = ""
    var body: some View {
        VStack {
            Button("Dismiss Modal") {
                presentationMode.wrappedValue.dismiss()
            }
            TextEditor(text: $text)
                .padding(20)
            Spacer()
            Button(action: { print("a") }) {
                HStack {
                    Image("write")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                    Text("멘토 요청하기")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.accentColor)
            }
        }
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
