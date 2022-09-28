//
//  CommentView.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/28.
//

import SwiftUI

struct CommentView: View {
    let data: CommentData
    var body: some View {
        Text(data.content)
    }
}
