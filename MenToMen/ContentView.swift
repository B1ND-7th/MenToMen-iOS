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
    var body: some View {
        VStack {
            PostsView()
            HStack {
                Spacer()
                
                Button(action: { }) {
                    VStack(spacing: 2) {
                        Image("home")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("홈")
                            .foregroundColor(Color(.label))
                            .font(.caption2)
                    }
                }
                
                Spacer()
                
                Button(action: { }) {
                    VStack(spacing: 2) {
                        Image("add-circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("등록")
                            .foregroundColor(Color(.label))
                            .font(.caption2)
                    }
                }
                .padding([.leading, .trailing], 30)
                
                Spacer()
                
                Button(action: { }) {
                    VStack(spacing: 2) {
                        Image("user")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("마이")
                            .foregroundColor(Color(.label))
                            .font(.caption2)
                    }
                }
                
                Spacer()
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
