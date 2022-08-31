//
//  RequestAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/31.
//

struct RequestData: Decodable {
    let status: Int
    let message: String
    let data: RequestDatas
}

struct RequestDatas: Decodable {
    let accessToken: String
}
