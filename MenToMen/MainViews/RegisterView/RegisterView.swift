//
//  RegisterView.swift
//  MenToMen
//
//  Created by Mercen on 2023/01/28.
//

//
// 급하게 작성한 코드라서 가독성이 부족합니다.
// 그런데 다른 코드도 정상은 아니라서...
//

import SwiftUI
import CryptoKit
import Alamofire
import AVFoundation

extension String {
    func isValidEmail() -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidId() -> Bool {

        let idRegEx = "[a-zA-Z0-9]{5,20}"
        
        let idTest = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: self)
    }
    
    func isValidPw() -> Bool {

        let pwRegEx = "[a-zA-Z0-9!@#$%^*+=-]{7,20}"
        
        let pwTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        return pwTest.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        let nameRegEx = "[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ]{2,12}"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func isValidGrade() -> Bool {
        let gradeRegEx = "[1-3]{1}"
        
        let gradeTest = NSPredicate(format:"SELF MATCHES %@", gradeRegEx)
        return gradeTest.evaluate(with: self)
    }
    
    func isValidClass() -> Bool {
        let classRegEx = "[1-3]{1}"
        
        let classTest = NSPredicate(format:"SELF MATCHES %@", classRegEx)
        return classTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let phoneRegEx = "[0-9]{10,11}"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self.removeHyphen())
    }
    
    func addHyphen() -> String {
        if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
            let modString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self), withTemplate: "$1-$2-$3")
            return modString
        }
        
        return self
    }
    
    func removeHyphen() -> String {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
    func isInt() -> Bool {
        return Int(self) != nil
    }
    
    func isValidNumber() -> Bool {
        return self.isInt() && !self.isEmpty && self.count < 3
    }
}

struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    
    @State var registerEmail: String = ""
    @State var registerId: String = ""
    @State var registerPw: String = ""
    @State var registerName: String = ""
    @State var registerPhone: String = ""
    @State var request: Bool = false
    @State var success: Bool = false
    @State var failure: Bool = false
    @State var failmsg: String = ""
    
    @State var registerGrade: String = ""
    @FocusState var gradeState: Bool
    @State var registerClass: String = ""
    @FocusState var classState: Bool
    @State var registerNumber: String = ""
    @FocusState var numberState: Bool
    
    @State var retry: Bool = false
    
    @State var status: Int = 0
    
    func changeState(_ stat: Bool, _ num: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            status = stat ? (status == num ? num + 1 : status) : num
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                dismiss()
            }) {
                Image("back")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(.label))
            }
            .frame(width: 30, height: 30)
            .padding(.leading, 10)
            .setAlignment(for: .leading)
            .frame(height: 61)
            NavigationLink(destination: RegisterSuccessView(), isActive: $success) { EmptyView() }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("도담도담 회원가입")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    CustomTextField(text: $registerEmail, retry: $retry, placeholder: "이메일을 입력하세요", type: .email)
                        .onChange(of: registerEmail) { value in
                            changeState(value.isValidEmail(), 0)
                        }
                    if status > 0 {
                        CustomTextField(text: $registerId, retry: $retry, placeholder: "아이디를 입력하세요")
                            .onChange(of: registerId) { value in
                                changeState(value.isValidId(), 1)
                            }
                            .onDisappear {
                                registerId = ""
                            }
                    }
                    if status > 1 {
                        CustomTextField(text: $registerPw, retry: $retry, placeholder: "비밀번호를 입력하세요", type: .secure)
                            .onChange(of: registerPw) { value in
                                changeState(value.isValidPw(), 2)
                            }
                            .onDisappear {
                                registerPw = ""
                            }
                    }
                    if status > 2 {
                        CustomTextField(text: $registerName, retry: $retry, placeholder: "이름을 입력하세요")
                            .onChange(of: registerName) { value in
                                changeState(value.isValidName(), 3)
                            }
                            .onDisappear {
                                registerName = ""
                            }
                    }
                    if status > 3 {
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer()
                            
                            Text("학생 정보를 입력하세요")
                                .scaleEffect(0.7, anchor: .leading)
                                .foregroundColor(gradeState || classState || numberState ? .accentColor : Color.gray)
                            
                            HStack(alignment: .bottom) {
                                TextField("", text: $registerGrade)
                                    .multilineTextAlignment(.center)
                                    .focused($gradeState)
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none)
                                    .onChange(of: registerGrade) { value in
                                        if registerGrade.isValidGrade() {
                                            classState = true
                                        } else {
                                            registerGrade = ""
                                        }
                                        changeState(registerGrade.isValidGrade() && registerClass.isValidClass() && registerNumber.isValidNumber(), 4)
                                    }
                                Text("학년")
                                    .foregroundColor(.gray)
                                TextField("", text: $registerClass)
                                    .multilineTextAlignment(.center)
                                    .focused($classState)
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none)
                                    .onChange(of: registerClass) { value in
                                        if registerClass.isValidGrade() {
                                            numberState = true
                                        } else {
                                            registerClass = ""
                                        }
                                        changeState(registerGrade.isValidGrade() && registerClass.isValidClass() && registerNumber.isValidNumber(), 4)
                                    }
                                Text("반")
                                    .foregroundColor(.gray)
                                TextField("", text: $registerNumber)
                                    .multilineTextAlignment(.center)
                                    .focused($numberState)
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none)
                                    .onChange(of: registerNumber) { value in
                                        if !registerNumber.isValidNumber() {
                                            registerNumber = ""
                                        }
                                        changeState(registerGrade.isValidGrade() && registerClass.isValidClass() && registerNumber.isValidNumber(), 4)
                                    }
                                Text("번")
                                    .foregroundColor(.gray)
                            }
                            .onDisappear {
                                registerGrade = ""
                                registerClass = ""
                                registerNumber = ""
                            }
                            Rectangle()
                                .fill(gradeState || classState || numberState ? .accentColor : Color.gray)
                                .frame(height: 1.3)
                                .padding(.top, 10)
                        }
                        .font(.title3)
                        .frame(height: 70)
                        .transition(.slide.combined(with: .opacity))
                        
                        if status > 4 {
                            CustomTextField(text: $registerPhone, retry: $retry, placeholder: "전화번호를 입력하세요", type: .numeric)
                                .onChange(of: registerPhone) { value in
                                    registerPhone = registerPhone.removeHyphen().addHyphen()
                                    changeState(value.isValidPhone(), 5)
                                }
                                .onDisappear {
                                    registerPhone = ""
                                }
                                .padding(.bottom, 20)
                        }
                        if status > 5 {
                            Button(action: {
                                request = true
                                AF.request("http://101.101.209.184:8080/api/auth/join-student",
                                           method: .post,
                                           parameters: ["email": registerEmail,
                                                        "grade": Int(registerGrade)!,
                                                        "id": registerId,
                                                        "name": registerName,
                                                        "number": Int(registerNumber)!,
                                                        "phone": registerPhone.removeHyphen(),
                                                        "pw":
                                                            SHA512.hash(data: registerPw.data(using: .utf8)!)
                                                                .compactMap{ String(format: "%02x", $0) }.joined(),
                                                        "room": Int(registerClass)!
                                                       ],
                                           encoding: JSONEncoding.default,
                                           headers: ["Content-Type": "application/json"]
                                ) { $0.timeoutInterval = 5 }
                                        .validate()
                                        .responseData { response in
                                            checkResponse(response)
                                            switch response.result {
                                            case .success:
                                                HapticManager.instance.notification(type: .success)
                                                AudioServicesPlaySystemSound(1407)
                                                success.toggle()
                                            case .failure:
                                                guard let result = try? decoder.decode(RegisterData.self, from: response.data!) else { return }
                                                failmsg = result.message
                                                failure.toggle()
                                            }
                                    }
                            }) {
                                Text("가입하기")
                                    .foregroundColor(Color(.systemBackground))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.accentColor)
                                    .clipShape(Capsule())
                            }
                            .disabled(request)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: 500)
            }
        }
        .alert(isPresented: $failure) {
            Alert(title: Text("오류"), message: Text(failmsg),
                  dismissButton: Alert.Button.default(Text("확인"), action: {
                request = false
            }))
        }
        .dragGesture(dismiss, $dragOffset)
        .navigationBarHidden(true)
    }
}

struct RegisterSuccessView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("success")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.bottom, 50)
            Text("회원가입 성공!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text("관리자의 승인을 기다려주세요!")
            Spacer()
            NavigationLink(destination: LoginView().navigationBarHidden(true)) {
                Text("확인")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
            }
            .clipped()
        }
        .navigationBarHidden(true)
    }
}
