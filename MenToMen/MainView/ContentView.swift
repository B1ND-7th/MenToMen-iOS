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

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedView: Int = 0
    var body: some View {
        VStack {
            switch(selectedView) {
                case 0: PostsView()
                case 1: WriteView()
                default: ProfileView()
            }
            HStack {
                Spacer()
                ForEach(0..<3, id: \.self) { idx in
                    Button(action: { selectedView = idx }) {
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
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.preferredColorScheme(.dark)
    }
}