//
//  LoginAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

struct CodeData: Decodable {
    let status: Int
    let message: String
    let data: CodeDatas
}

struct CodeDatas: Decodable {
    let name: String
    let profileImage: String
    let location: String
}

struct LoginData: Decodable {
    let status: Int
    let message: String
    let data: LoginDatas
}

struct LoginDatas: Decodable {
    let accessToken: String
    let refreshToken: String
}
