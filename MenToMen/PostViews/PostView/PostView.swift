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
    @State var commentDeleteAlert: Bool = false
    @State var commentWriteToggles: Bool = false
    @State var currentComment: String = ""
    @State var userName: String = ""
    @State var stdInfo: InfoDatas = InfoDatas(grade: 0, room: 0, number: 0)
    @State var profileUrl: String? = ""
    @State var selectedCommentId: Int = 0
    @State var tap: Bool = false
    @State var more: Bool = false
    @State var commentMore: [Int] = [Int]()
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
        AF.request("\(api)/user/my",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 5 }
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(ProfileData.self, from: value) else { return }
                userName = result.data.name
                stdInfo = result.data.stdInfo
                profileUrl = result.data.profileImage
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
                        withAnimation(.default) {
                            comments = result.data
                        }
                    case .failure(let error):
                        errorToggle.toggle()
                        print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                    }
                }
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
                    HStack {
                        PersonView(profileUrl: data.profileUrl,
                                   userName: data.userName,
                                   stdInfo: data.stdInfo,
                                   author: data.author)
                        Spacer()
                        if data.author == userId {
                            if more {
                                Button(action: {
                                    writeToggles.toggle()
                                }) {
                                    Image("write")
                                        .renderIcon()
                                }
                                .frame(width: 25, height: 25)
                                Button(action: {
                                    deleteAlert.toggle()
                                }) {
                                    Image("trash")
                                        .renderIcon()
                                }
                                .frame(width: 25, height: 25)
                                .padding([.leading, .trailing], 5)
                            } else {
                                Button(action: {
                                    withAnimation(.default) {
                                        more.toggle()
                                    }
                                }) {
                                    Image("more")
                                        .renderIcon()
                                }
                                .frame(width: 25, height: 25)
                            }
                        }
                    }
                    .padding(.bottom, 10)
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
                VStack(spacing: 0) {
                    ForEach(comments, id: \.self) { comment in
                        HStack {
                            PersonView(profileUrl: comment.profileUrl,
                                       userName: comment.userName,
                                       stdInfo: comment.stdInfo,
                                       author: comment.userId)
                            Spacer()
                            if comment.userId == userId {
                                if commentMore.contains(comment.commentId) {
                                    Button(action: {
                                        commentWriteToggles.toggle()
                                    }) {
                                        Image("write")
                                            .renderIcon()
                                    }
                                    .frame(width: 25, height: 25)
                                    Button(action: {
                                        selectedCommentId = comment.commentId
                                        commentDeleteAlert.toggle()
                                    }) {
                                        Image("trash")
                                            .renderIcon()
                                    }
                                    .frame(width: 25, height: 25)
                                    .padding([.leading, .trailing], 5)
                                } else {
                                    Button(action: {
                                        withAnimation(.default) {
                                            commentMore.append(comment.commentId)
                                        }
                                    }) {
                                        Image("more")
                                            .renderIcon()
                                    }
                                    .frame(width: 25, height: 25)
                                }
                            }
                        }
                        .padding([.leading, .top, .trailing])
                        Text(comment.content)
                            .customComment()
                        Rectangle()
                            .fill(Color("M2MBackground"))
                            .frame(height: 1)
                    }
                    HStack {
                        PersonView(profileUrl: profileUrl,
                                   userName: userName,
                                   stdInfo: stdInfo,
                                   author: -1)
                        Spacer()
                        Button(action: {
                            AF.request("\(api)/comment/submit",
                                       method: .post,
                                       parameters: ["content": currentComment,
                                                    "postId": data.postId],
                                       encoding: JSONEncoding.default,
                                       headers: ["Content-Type": "application/json"],
                                       interceptor: Requester()
                            ) { $0.timeoutInterval = 5 }
                                .validate()
                                .responseData { response in
                                    checkResponse(response)
                                    switch response.result {
                                    case .success:
                                        loadComments()
                                        currentComment = ""
                                    case .failure: print("Error")
                                    }
                                }
                        }) {
                            Image("send")
                                .renderIcon()
                        }
                        .frame(width: 25, height: 25)
                    }
                    .padding([.leading, .top, .trailing])
                    TextField("", text: $currentComment)
                        .placeholder("댓글을 입력해주세요", when: currentComment.isEmpty)
                        .customComment()
                }
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
        .confirmationDialog("댓글 삭제", isPresented: $commentDeleteAlert) {
            Button("정말 삭제하시겠습니까?", role: .destructive) {
                AF.request("\(api)/comment/delete/\(selectedCommentId)",
                           method: .delete,
                           encoding: JSONEncoding.default,
                           headers: ["Content-Type": "application/json"],
                           interceptor: Requester()
                ) { $0.timeoutInterval = 5 }
                        .validate()
                        .responseData { response in
                            checkResponse(response)
                            loadComments()
                    }
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("삭제한 댓글은 복구할 수 없습니다")
        }
        .dragGesture(dismiss, $dragOffset)
        .exitAlert($errorToggle)
        .navigationBarHidden(true)
    }
}
