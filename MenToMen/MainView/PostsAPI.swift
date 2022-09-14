//
//  PostsAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

struct PostsData: Decodable {
    let status: Int
    let message: String
    let data: [PostDatas]
}
