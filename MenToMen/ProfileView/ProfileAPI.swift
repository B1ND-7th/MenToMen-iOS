//
//  ProfileAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/30.
//

import Foundation

struct ProfileData: Decodable {
    let status: Int
    let message: String
    let data: ProfileDatas
}

struct ProfileDatas: Decodable {
    let name: String
    let email: String
    let profileImage: String?
    let stdInfo: InfoDatas
    let userId: Int
}

struct InfoDatas: Decodable, Hashable {
    let grade: Int
    let room: Int
    let number: Int
}
