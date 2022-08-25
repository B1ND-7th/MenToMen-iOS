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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct ContentView: View {
    @State var selectedView = 0
    var body: some View {
        VStack {
            switch(selectedView) {
                case 0: PostsView()
                case 1: Text("a")
                default:Text("b")
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
                    .padding(.bottom, 5)
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.preferredColorScheme(.dark)
    }
}
