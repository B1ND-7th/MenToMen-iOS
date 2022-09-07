//
//  ProfileView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/26.
//

import SwiftUI
import Alamofire

struct ProfileView: View {
    @State var name: String = "이석호"
    @State var profileImage: String = "null"
    @State var info: String = "1학년 2반 11번"
    @State var email: String = "mercen@mercen.net"
    let decoder: JSONDecoder = JSONDecoder()
    func load() {
        AF.request("\(api)/user/my",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 10 }
        .validate()
        .responseData { response in
            checkResponse(response)
            switch response.result {
            case .success:
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(ProfileData.self, from: value) else { return }
                let data = result.data
                self.name = data.name
                self.profileImage = data.profileImage ?? ""
                self.info = "\(data.stdInfo.grade)학년 \(data.stdInfo.room)반 \(data.stdInfo.number)번"
                self.email = data.email
            case .failure(let error):
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                BarView(searchButton: false)
                List {
                    HStack {
                        AsyncImage(url: URL(string: profileImage)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            switch profileImage.count {
                            case 0: Image("profile")
                                    .resizable()
                            default: ProgressView()
                            }
                        }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(info)
                            Text("\(name)님, 환영합니다!")
                                .fontWeight(.bold)
                                .font(.title2)
                            Text(email)
                                .fontWeight(.light)
                        }
                        Spacer()
                    }
                    .customCell()
                }
                .listStyle(PlainListStyle())
                .background(Color("M2MBackground"))
            }
            .navigationBarHidden(true)
            .navigationTitle("")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
