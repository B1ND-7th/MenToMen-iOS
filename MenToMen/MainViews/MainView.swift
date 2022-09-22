//
//  MainView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI
import SlideOverCard

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedView: Int = 0
    @State var writeToggles: Bool = false
    @State var logout: Bool = false
    @State var status: Int = 0
    @State var tutorial: Bool = false
    @State var postdata: PostDatas = PostDatas(author: 0, content: "", imgUrl: "", createDateTime: "", updateDateTime: "", updateStatus: "", postId: 0, profileUrl: "", tag: "", userName: "", stdInfo: InfoDatas(grade: 1, room: 1, number: 1))

    @State var postlink: Bool = false
    @State var postuser: Int = 0
    @State var transition: AnyTransition = .slide
    func tutorialFinished() {
        UserDefaults.standard.set(true, forKey: "homeTutorial")
        SOCManager.dismiss(isPresented: $tutorial)
    }
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color(.secondarySystemGroupedBackground))
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: LoginView()
                        .navigationBarHidden(true), isActive: $logout) { EmptyView() }
                    NavigationLink(destination: PostView(data: postdata, userId: postuser)
                        .navigationBarHidden(true), isActive: $postlink) { EmptyView() }
                    switch(selectedView) {
                    case 0: PostsView(postdata: $postdata,
                                      postlink: $postlink,
                                      postuser: $postuser)
                    .transition(transition)
                    default: ProfileView(logout: $logout,
                                         postdata: $postdata,
                                         postlink: $postlink,
                                         postuser: $postuser)
                    .transition(transition)
                    }
                    HStack {
                        Spacer()
                        ForEach(0..<3, id: \.self) { idx in
                            Button(action: {
                                HapticManager.instance.impact(style: .light)
                                if idx == 1 {
                                    writeToggles.toggle()
                                } else {
                                    switch(idx) {
                                    case 0: transition = .slide
                                    default: transition = .backslide
                                    }
                                    withAnimation(.easeInOut) {
                                        selectedView = idx
                                    }
                                }
                            }) {
                                VStack(spacing: 2) {
                                    Image(["home", "add-circle", "user"][idx])
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 25, height: 25)
                                    Text(["홈", "등록", "마이"][idx])
                                        .font(.caption2)
                                }
                                .foregroundColor(idx == selectedView ? .accentColor : Color(.label))
                            }
                            .padding([.leading, .trailing], idx == 1 ? 30 : 0)
                            .padding(.bottom, 6)
                            Spacer()
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
            }
            .fullScreenCover(isPresented: $writeToggles, content: {
                WriteView(data: nil)
            })
            .navigationBarHidden(true)
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "homeTutorial") {
                    tutorial.toggle()
                }
            }
            .slideOverCard(isPresented: $tutorial,
                           options: [.hideDismissButton, .disableDragToDismiss],
                           style: SOCStyle(continuous: false,
                                           innerPadding: 16.0, outerPadding: 4.0,
                                           style: Color(.secondarySystemGroupedBackground))) {
                VStack {
                    VStack(spacing: 5) {
                        Text("멘투멘 둘러보기")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        Text(["멘토 요청 게시글을 확인해보세요",
                              "게시글 분야 필터를 사용해보세요",
                              "게시글 검색 기능을 사용해보세요",
                              "알림 메시지 목록을 확인해보세요"][status])
                        if status == 0 {
                            GifView(fileName: "homeTutorial1")
                                .tutorialFrame()
                        } else if status == 1 {
                            GifView(fileName: "homeTutorial2")
                                .tutorialFrame()
                        } else if status == 2 {
                            GifView(fileName: "homeTutorial3")
                                .tutorialFrame()
                        } else {
                            GifView(fileName: "homeTutorial4")
                                .tutorialFrame()
                        }
                    }
                    Button(action: {
                        if status != 3 {
                            status += 1
                        } else {
                            tutorialFinished()
                        }
                    }) {
                        Text(status != 3 ? "다음" : "완료")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(.systemBackground))
                            .background(Color.accentColor)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.bottom, 5)
                    if status != 3 {
                        Button(action: tutorialFinished) {
                            Text("건너뛰기")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            //.preferredColorScheme(.dark)
    }
}
