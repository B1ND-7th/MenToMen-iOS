//
//  LoginAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

struct LoginData: Decodable {
    let status: Int
    let message: String
    let data: datas
}

struct datas: Decodable {
    let name: String
    let profileImage: String
    let location: String
}
