//
//  LoginView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var numOfShakes: CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
}

struct AndroidTextField: View {
    @FocusState private var focus: Bool
    @Binding var text: String
    let type: Int
    var body: some View {
        VStack {
            switch(type) {
            case 0: TextField("아이디", text: $text)
                    .focused($focus)
            default: SecureField("비밀번호", text: $text)
                    .focused($focus)
            }
            Rectangle()
                .fill(focus ? .accentColor : Color(.systemGray3))
                .frame(height: 1.3)
        }
        .font(.title2)
        .padding(.top, 25)
    }
}

struct LoginView: View {
    @State var loginId: String = ""
    @State var loginPw: String = ""
    @State var invalid = 0
    @State var success = false
    var body: some View {
        VStack {
            Spacer()
            Image("M2MLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.accentColor)
                .frame(width: 250, height: 84.5)
            VStack(alignment: .leading) {
                AndroidTextField(text: $loginId, type: 0)
                AndroidTextField(text: $loginPw, type: 1)
                Text("아이디 또는 비밀번호가 틀렸습니다")
                    .foregroundColor(.accentColor)
                    .isHidden(invalid == 0)
            }
            .modifier(ShakeEffect(animatableData: CGFloat(invalid)))
            Spacer()
            Text("로그인")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.accentColor)
                .foregroundColor(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .padding(20)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
