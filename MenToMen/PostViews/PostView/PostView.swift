//
//  PostView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI
import Alamofire
import CachedAsyncImage

struct PostView: View {
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    @State var errorToggle: Bool = false
    @State var deleteAlert: Bool = false
    @State var writeToggles: Bool = false
    @State var data: PostDatas
    @State var comments = [CommentData]()
    @State var tap: Bool = false
    let profileImage: String = ""
    let userId: Int
    func timeParser(_ original: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: original
            .components(separatedBy: ".")[0])
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 a h:mm"
        return formatter.string(from: date!)
    }
    func tapper(_ state: Bool) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            tap = state
        }
    }
    func loadComments() {
        AF.request("\(api)/comment/read/\(data.postId)",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 5 }
        .validate()
        .responseData { response in
            checkResponse(response)
            switch response.result {
            case .success:
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(CommentDatas.self, from: value) else { return }
                comments = result.data
            case .failure(let error):
                errorToggle.toggle()
                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
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
            .background(Color(.secondarySystemGroupedBackground))
            ScrollView {
                VStack(spacing: 0) {
                    PersonView(writeToggles: $writeToggles,
                               deleteAlert: $deleteAlert,
                               profileUrl: data.profileUrl,
                               userName: data.userName,
                               stdInfo: data.stdInfo,
                               author: data.author,
                               userId: userId)
                    Text(data.content)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if data.imgUrl != nil {
                        CachedAsyncImage(url: URL(string: data.imgUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                .padding(.top, 10)
                                .scaleEffect(tap ? 0.95 : 1)
                                .onTapGesture { }
                                .onLongPressGesture(minimumDuration: 0.3) {
                                    HapticManager.instance.impact(style: .medium)
                                    tapper(true)
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    Text("""
                         \(timeParser(data.createDateTime)) 작성\
                         \(data.updateStatus == "UPDATE" ? "\n\(timeParser(data.updateDateTime)) 수정" : "")
                         """)
                        .font(.caption)
                        .padding([.top], 10)
                        .foregroundColor(.gray)
                        .setAlignment(for: .trailing)
                }
                .padding()
                .customCell()
                .onAppear {
                    print(try! getToken("accessToken"))
                }
                VStack {
                    ForEach(comments, id: \.self) { comment in
                        PersonView(writeToggles: $writeToggles,
                                   deleteAlert: $deleteAlert,
                                   profileUrl: comment.profileUrl,
                                   userName: comment.userName,
                                   stdInfo: comment.stdInfo,
                                   author: comment.userId,
                                   userId: userId)
                        Text(comment.content)
                            .setAlignment(for: .leading)
                    }
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
                ) { $0.timeoutInterval = 5 }
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
                        errorToggle.toggle()
                        print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                    }
                }
                loadComments()
            }
            .onAppear {
                loadComments()
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .fullScreenCover(isPresented: $writeToggles, content: {
            WriteView(data: data)
        })
        .confirmationDialog("저장", isPresented: $tap) {
            Button("사진 앨범에 추가") {
                tapper(false)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: URL(string: data.imgUrl!)!)
                    DispatchQueue.main.async {
                        if data != nil {
                            UIImageWriteToSavedPhotosAlbum(UIImage(data: data!)!, nil, nil, nil)
                        }
                    }
                }
            }
            Button("취소", role: .cancel) {
                tapper(false)
            }
        }
        .confirmationDialog("삭제", isPresented: $deleteAlert) {
            Button("정말 삭제하시겠습니까?", role: .destructive) {
                AF.request("\(api)/post/delete/\(data.postId)",
                           method: .delete,
                           encoding: JSONEncoding.default,
                           headers: ["Content-Type": "application/json"],
                           interceptor: Requester()
                ) { $0.timeoutInterval = 5 }
                        .validate()
                        .responseData { response in
                            checkResponse(response)
                            dismiss()
                    }
            } 
            Button("취소", role: .cancel) { }
        } message: {
            Text("삭제한 게시글은 복구할 수 없습니다")
        }
        .dragGesture(dismiss, $dragOffset)
        .exitAlert($errorToggle)
        .navigationBarHidden(true)
    }
}
