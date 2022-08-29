//
//  NotifyCell.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

import SwiftUI

struct NotifyCell: View {
    var body: some View {
        HStack {
            Image("Dog")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            Text("이석호님이 당신의 멘토 요청을 수락하셨습니다.")
            Spacer()
        }
    }
}

struct NotifyCell_Previews: PreviewProvider {
    static var previews: some View {
        NotifyCell()
    }
}
