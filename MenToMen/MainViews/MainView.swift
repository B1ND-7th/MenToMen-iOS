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
    @FocusState var searchState: Bool
    @State var selectedView: Int = 0
    @State var writeToggles: Bool = false
    @State var logout: Bool = false
    @State var status: Int = 0
    @State var tutorial: Bool = false
    @State var postdata: PostDatas = PostDatas(author: 0, content: "", imgUrls: [""], createDateTime: "", updateDateTime: "", updateStatus: "", postId: 0, profileUrl: "", tag: "", userName: "", stdInfo: InfoDatas(grade: 1, room: 1, number: 1))
    @State var postlink: Bool = false
    @State var postuser: Int = 0
    @State var searchToggle: Bool = false
    @State var searchText: String = ""
    @State var refresh: Bool = false
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
                NavigationLink(destination: LoginView()
                    .navigationBarHidden(true), isActive: $logout) { EmptyView() }
                NavigationLink(destination: PostView(refresh: $refresh, data: postdata, userId: postuser)
                    .navigationBarHidden(true), isActive: $postlink) { EmptyView() }
                Group {
                    switch(selectedView) {
                    case 0: PostsView(postdata: $postdata,
                                      postlink: $postlink,
                                      postuser: $postuser,
                                      searchText: $searchText,
                                      refresh: $refresh)
                    default: ProfileView(logout: $logout,
                                         postdata: $postdata,
                                         postlink: $postlink,
                                         postuser: $postuser,
                                         refresh: $refresh)
                    }
                }
                    .padding(.top, 61)
                Button(action: {
                    HapticManager.instance.impact(style: .light)
                    writeToggles.toggle()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .padding(15)
                        .background(.blue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
                }
                .setAlignment(for: .bottom)
                .padding(.bottom, 25)
                .ignoresSafeArea(.keyboard)
                HStack {
                    Spacer()
                    ForEach(0..<2, id: \.self) { idx in
                        Button(action: {
                            HapticManager.instance.impact(style: .light)
                            withAnimation(.default) {
                                selectedView = idx
                            }
                        }) {
                            VStack(spacing: 2) {
                                Image(["home", "user"][idx])
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 25, height: 25)
                                Text(["홈", "마이"][idx])
                                    .font(.caption2)
                            }
                            .foregroundColor(idx == selectedView ? .accentColor : Color(.label))
                        }
                        .padding(.bottom, 6)
                        if idx == 0 {
                            Spacer()
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .padding(.top, 5)
                .padding(.bottom, UIApplication
                    .shared
                    .connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }?.safeAreaInsets.bottom)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(CustomShape())
                .setAlignment(for: .bottom)
                .ignoresSafeArea()
                .shadow(color: .black.opacity(0.2), radius: 3)
                HStack(spacing: 15) {
                    if !searchToggle {
                        Image("M2MLogo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(.label))
                            .frame(width: 100, height: 33.8)
                        Spacer()
                    }
                    if selectedView == 0 {
                        if searchToggle {
                            TextField("검색어를 입력해주세요", text: $searchText)
                                .focused($searchState)
                                .font(.title3)
                                .frame(height: 33.8)
                        }
                        Button(action: {
                            withAnimation(.default) {
                                if !searchToggle || searchText.isEmpty {
                                    searchToggle.toggle()
                                    searchState.toggle()
                                } else {
                                    searchState = false
                                }
                            }
                        }) {
                            Image("search-normal")
                                .renderIcon()
                        }
                        .frame(width: 25, height: 25)
                    }
                    if !searchToggle {
                        NavigationLink(destination: NotifyView()) {
                            ZStack {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .position(x: 22, y: 0)
                                Image("notification")
                                    .renderIcon()
                            }
                        }
                        .frame(width: 25, height: 25)
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 16)
                .padding(.top, 12)
                .background(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.2), radius: 3)
                .frame(height: 61)
                .frame(maxWidth: .infinity)
                .setAlignment(for: .top)
            }
        }
        .fullScreenCover(isPresented: $writeToggles, content: {
            WriteView(refresh: $refresh, data: nil)
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
        .navigationBarHidden(true)
    }
}
