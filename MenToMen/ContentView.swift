//
//  ContentView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/25.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            Button("Dismiss Modal") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedView: Int = 0
    @State var navbarHidden: Bool = false
    @State var navbarUpdown: Bool = false
    @State var writeToggles: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(.secondarySystemGroupedBackground))
                .ignoresSafeArea()
            VStack {
                switch(selectedView) {
                case 0: PostsView(navbarHidden: $navbarHidden,
                                  navbarUpdown: $navbarUpdown)
                default: ProfileView()
                }
                HStack {
                    Spacer()
                    ForEach(0..<3, id: \.self) { idx in
                        Button(action: {
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
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $writeToggles, content: WriteView.init)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.preferredColorScheme(.dark)
    }
}
