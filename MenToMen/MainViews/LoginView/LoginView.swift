//
//  LoginView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import CryptoKit
import Alamofire
import AVFoundation

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var numOfShakes: CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
}

struct LoginView: View {
    @State var invalidMessage: String = ""
    @State var loginId: String = ""
    @State var loginPw: String = ""
    @State var invalid: Int = 0
    @State var success: Bool = false
    @State var request: Bool = false
    @State var tfstate: Bool = false
    func toggleFailure(_ messageType: Int) {
        HapticManager.instance.notification(type: .error)
        invalidMessage = messageType == 1 ? "ID 또는 비밀번호가 틀렸습니다" : "서버에 연결할 수 없습니다"
        withAnimation(.default) {
            tfstate = true
            request = false
            invalid += 1
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("M2MLogo")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.accentColor)
                    .scaledToFit()
                    .frame(width: 250)
                VStack(alignment: .leading, spacing: 5) {
                    CustomTextField(text: $loginId, retry: $tfstate, placeholder: "도담도담 ID")
                    CustomTextField(text: $loginPw, retry: $tfstate, placeholder: "비밀번호", type: .secure)
                    if invalid != 0 && tfstate {
                        Text(invalidMessage)
                            .foregroundColor(.accentColor)
                    }
                }
                .modifier(ShakeEffect(animatableData: CGFloat(invalid)))
                .padding(.bottom, 30)
                NavigationLink(destination: MainView(), isActive: $success) { EmptyView() }
                Button(action: {
                    request = true
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
                    ) { $0.timeoutInterval = 5 }
                            .validate()
                            .responseData { response in
                                checkResponse(response)
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? decoder.decode(CodeData.self, from: value) else { return }
                                    let code = result.data.location.components(separatedBy: ["=", "&"])[1]
                                    AF.request("\(api)/auth/code",
                                               method: .post,
                                               parameters: ["code": code],
                                               encoding: JSONEncoding.default,
                                               headers: ["Content-Type": "application/json"]
                                    ) { $0.timeoutInterval = 5 }
                                        .validate()
                                        .responseData { response in
                                        switch response.result {
                                        case .success:
                                            guard let value = response.value else { return }
                                            guard let result = try? decoder.decode(LoginData.self, from: value) else { return }
                                            try? saveToken(result.data.accessToken, "accessToken")
                                            try? saveToken(result.data.refreshToken, "refreshToken")
                                            HapticManager.instance.notification(type: .success)
                                            AudioServicesPlaySystemSound(1407)
                                            success.toggle()
                                        case .failure:
                                            toggleFailure(0)
                                        }
                                    }
                                case .failure:
                                    toggleFailure((response.response?.statusCode)! == 401 ? 1 : 0)
                                }
                        }
                }) {
                    Text("로그인")
                        .foregroundColor(Color(.systemBackground))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                }
                .disabled(loginId.isEmpty || loginPw.isEmpty || request)
                NavigationLink(destination: RegisterView()) {
                    Text("도담도담 회원가입")
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.systemBackground))
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.accentColor, lineWidth: 1.3)
                        )
                }
                Spacer()
            }
            .frame(maxWidth: 500)
            .padding(40)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}
