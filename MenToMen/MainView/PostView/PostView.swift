//
//  PostView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import Alamofire

struct PostView: View {
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    @State var data: PostDatas
    let profileImage: String = ""
    func timeParser(_ original: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: original
            .components(separatedBy: ".")[0])
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 a h:mm"
        return formatter.string(from: date!)
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
            .background(Color(.secondarySystemGroupedBackground))
            List {
                VStack(spacing: 0) {
                    HStack {
                        AsyncImage(url: URL(string: data.profileUrl ?? "")) { image in
                            image
                                .resizable()
                        } placeholder: {
                            if data.profileUrl == nil {
                                Image("profile")
                                    .resizable()
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(data.userName)
                            Text("\(data.stdInfo.grade)학년 \(data.stdInfo.room)반 \(data.stdInfo.number)번")
                        }
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    Text(data.content)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    AsyncImage(url: URL(string: data.imgUrl ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .padding(.top, 10)
                    } placeholder: {
                        ProgressView()
                    }
                    .isHidden(data.imgUrl == nil, remove: true)
                    Text(timeParser(data.localDateTime))
                        .font(.caption)
                        .padding([.top, .trailing], 10)
                        .foregroundColor(.gray)
                        .setAlignment(for: .trailing)
                }
                .padding()
                .customCell()
            }
            .customList()
            .refreshable {
                AF.request("\(api)/post/read-one/\(data.postId)",
                           method: .get,
                           encoding: URLEncoding.default,
                           headers: ["Content-Type": "application/json"],
                           interceptor: Requester()
                ) { $0.timeoutInterval = 10 }
                .validate()
                .responseData { response in
                    checkResponse(response)
                    print(checkStatus(response))
                    switch response.result {
                    case .success:
                        guard let value = response.value else { return }
                        guard let result = try? decoder.decode(PostData.self, from: value) else { return }
                        data = result.data
                    case .failure(let error):
                        print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                    }
                }
            }
        }
        .dragGesture(dismiss, $dragOffset)
        .navigationBarHidden(true)
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView()
//    }
//}
