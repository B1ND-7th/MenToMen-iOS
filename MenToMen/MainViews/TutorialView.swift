//
//  TutorialView.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/16.
//

import SwiftUI

struct TutorialView: View {
    let title: String
    let description: String
    let image: String
    var body: some View {
            VStack(spacing: 5) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text(description)
                    .padding(.bottom, 15)
                Image(image)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.bottom, 10)
            }
    }
}
