//
//  BarView.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/07.
//

import SwiftUI

struct BarView: View {
    let searchButton: Bool
    var body: some View {
        HStack(spacing: 15) {
            Image("M2MLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(.label))
                .frame(width: 100, height: 33.8)
            Spacer()
            if searchButton {
                Button(action: { }) {
                    Image("search-normal")
                        .renderIcon()
                }
                .frame(width: 25, height: 25)
            }
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
        .padding([.leading, .trailing], 20)
        .padding(.bottom, 16)
        .padding(.top, 12)
        .background(Color(.secondarySystemGroupedBackground))
    }
}
