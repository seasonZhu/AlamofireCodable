//
//  Model1.swift
//  AlamofireCodableDemo
//
//  Created by season on 2019/2/25.
//  Copyright © 2019 season. All rights reserved.
//

import Foundation

/*
 遵守Codable协议的struct
 */

struct Item: Codable {
    var topicOrder: Int?
    var id: Int?
    var topicDesc: String?
    var topicTittle: String?
    var upTime: String?
    var topicImageUrl: String?
    var topicStatus: Int?
}

struct Topics: Codable {
    var list: [Item]?
    var code: Int?
}
