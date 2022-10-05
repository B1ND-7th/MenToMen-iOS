//
//  PostAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/05.
//

struct PostData: Decodable {
    let status: Int
    let message: String
    let data: PostDatas
}

struct PostDatas: Decodable {
    let author: Int
    let content: String
    let imgUrls: [String]
    let createDateTime: String
    let updateDateTime: String
    let updateStatus: String
    let postId: Int
    let profileUrl: String?
    let tag: String?
    let userName: String
    let stdInfo: InfoDatas
}

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
