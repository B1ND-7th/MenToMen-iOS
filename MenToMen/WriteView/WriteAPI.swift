//
//  WriteAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/05.
//

struct ImageData: Decodable {
    let status: Int
    let message: String
    let data: [ImageDatas]
}

struct ImageDatas: Decodable {
    let imgUrl: String
}
