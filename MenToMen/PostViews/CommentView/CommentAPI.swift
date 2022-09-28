//
//  CommentAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/28.
//
//

struct CommentDatas: Decodable, Hashable {
    let data: [CommentData]
    let message: String
    let status: Int
}

struct CommentData: Decodable, Hashable {
    let commentId: Int
    let content: String
    let createDateTime: String
    let postId: Int
    let profileUrl: String?
    let stdInfo: InfoDatas
    let updateDateTime: String?
    let userId: Int
    let userName: String
}
