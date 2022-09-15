//
//  MainView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedView: Int = 0
    @State var navbarHidden: Bool = false
    @State var navbarUpdown: Bool = false
    @State var writeToggles: Bool = false
    @State var logout: Bool = false
    @State var status: [Int] = [0, 70, 0, 0, 0]
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color(.secondarySystemGroupedBackground))
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: LoginView()
                        .navigationBarHidden(true), isActive: $logout) { EmptyView() }
                    switch(selectedView) {
                    case 0: PostsView(navbarHidden: $navbarHidden,
                                      navbarUpdown: $navbarUpdown)
                    default: ProfileView(navbarHidden: $navbarHidden,
                                         navbarUpdown: $navbarUpdown,
                                         logout: $logout)
                    }
                    HStack {
                        Spacer()
                        ForEach(0..<3, id: \.self) { idx in
                            Button(action: {
                                HapticManager.instance.impact(style: .light)
                                if idx == 1 {
                                    writeToggles.toggle()
                                } else {
                                    selectedView = idx
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
                    .opacity(navbarHidden ? 0 : 1)
                    .isHidden(navbarUpdown, remove: true)
                }
                .background(Color(.secondarySystemGroupedBackground))
//                VStack(spacing: 0) {
//                    Color.black
//                        .opacity(0.5)
//                        .frame(height: CGFloat(status[1]))
//                        .padding(.bottom, CGFloat(status[2]))
//                    Color.black
//                        .opacity(0.5)
//                }
//                Button(action: {
//                    withAnimation(.default) {
//                        switch(status[0]) {
//                        case 0:
//                            status[2] = 40
//                        case 1:
//                            status[2] = 400
//                        case 2:
//                            status[2] = 40
//                        default:
//                            status[2] = 0
//                        }
//                    }
//                    status[0] += 1
//                }) {
//                    Text("Next")
//                }
            }
            .fullScreenCover(isPresented: $writeToggles, content: WriteView.init)
            .navigationBarHidden(true)
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
