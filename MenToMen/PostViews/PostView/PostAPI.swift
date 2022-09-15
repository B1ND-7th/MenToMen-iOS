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
    let content: String
    let imgUrl: String?
    let localDateTime: String
    let postId: Int
    let profileUrl: String?
    let tag: String?
    let userName: String
    let stdInfo: InfoDatas
}