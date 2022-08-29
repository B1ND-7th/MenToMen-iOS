//
//  LoginView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import CryptoKit
import Alamofire

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
    let decoder: JSONDecoder = JSONDecoder()
    @State var loginId: String = ""
    @State var loginPw: String = ""
    @State var invalid: Int = 0
    @State var success: Bool = false
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
            Button(action: {
                AF.request("http://dauth.b1nd.com/api/auth/login",
                           method: .post,
                           parameters: ["id": loginId, "pw":
                                            SHA512.hash(data: loginPw.data(using: .utf8)!)
                                                .compactMap{ String(format: "%02x", $0) }.joined(),
                                        "clientId": "39bc523458c14eb987b7b16175426a31a9f105b7f5814f1f9eca7d454bd23c73",
                                        "redirectUrl": "http://localhost:3000/callback",
                                        "state": "null"
                                       ],
                           encoding: JSONEncoding.default,
                           headers: ["Content-Type": "application/json"]
                )
                        .responseData { response in
                            switch response.result {
                            case .success:
                                if (response.response?.statusCode)! == 200 {
                                    guard let value = response.value else { return }
                                    guard let result = try? decoder.decode(LoginData.self, from: value) else { return }
                                    let code = result.data.location.components(separatedBy: ["=", "&"])[1]
                                    AF.request("\(api)/auth/code",
                                               method: .post,
                                               parameters: ["code": code],
                                               encoding: JSONEncoding.default,
                                               headers: ["Content-Type": "application/json"]
                                    )
                                    .responseData { response in
                                        print(String(decoding: response.data!, as: UTF8.self))
                                    }
                                    //UserDefaults.standard.set(code, forKey: "token")
                                    success.toggle()
                                } else {
                                    withAnimation(.default) {
                                    self.invalid += 1
                                }
                            }
                            case .failure(let error):
                                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                            }
                    }
            }) {
                Text("로그인")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(20)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
