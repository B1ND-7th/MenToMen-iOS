//
//  NotifyAPI.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/29.
//

struct NotifyData: Decodable {
    let status: Int
    let message: String
    let data: [NotifyDatas]
}

struct NotifyDatas: Decodable {
    let commentContent: String
    let createDateTime: String
    let noticeStatus: String
    let postId: Int
    let senderName: String
    let senderProfileImage: String?
}

struct AlertData: Decodable {
    let status: Int
    let message: String
    let data: AlertDatas
}

struct AlertDatas: Decodable {
    let noticeStatus: String
}
