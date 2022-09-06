//
//  PostsAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

struct PostData: Decodable {
    let status: Int
    let message: String
    let data: [PostDatas]
}

struct PostDatas: Decodable {
    let content: String
    let imgUrl: String?
    let localDateTime: String
    let postId: Int
    let profileUrl: String?
    let tags: String?
    let userName: String
}
