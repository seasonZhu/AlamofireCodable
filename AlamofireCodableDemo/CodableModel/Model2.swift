//
//  Model2.swift
//  AlamofireCodableDemo
//
//  Created by season on 2019/2/25.
//  Copyright © 2019 season. All rights reserved.
//

import Foundation

/*
 遵守Codable协议的class
 */

class U17Root: Codable {
    
    var code: Int?
    var data: U17Data?
}

class U17Data: Codable {
    
    var message: String?
    var returnData: ReturnData?
    var stateCode: Int?
}

class ReturnData: Codable {
    
    var comicLists: [ComicList]?
    var editTime: String?
    var galleryItems: [GalleryItem]?
    
    /// 这个是我自定义的模型属性
    var isMoreThanOneComic: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case comicLists = "comicLists"
        case editTime = "editTime"
        case galleryItems = "galleryItems"
    }
    
    init() { }
    
    /*
     如果模型里面有自定义的属性
     也就是根据从服务器获取JSON推导出来的其他属性赋值的时候
     需要写出Decodable协议实现的完整方法,注意 将init() {}也声明出来,否者你根本没有一个正常的初始化方法可以用
     */
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comicLists = try values.decodeIfPresent([ComicList].self, forKey: .comicLists)
        editTime = try values.decodeIfPresent(String.self, forKey: .editTime)
        galleryItems = try values.decodeIfPresent([GalleryItem].self, forKey: .galleryItems)
        
        // 自定义模型属性的赋值
        if let comicLists = comicLists, comicLists.count > 1 {
            isMoreThanOneComic = true
        }else {
            isMoreThanOneComic = false
        }
    }
    
    
}

class GalleryItem: Codable {
    
    var content: String?
    var cover: String?
    var ext: [Ext]?
    var id: Int?
    var linkType: Int?
    var title: String?
}

class Ext: Codable {
    
    var key: String?
    var val: String?
}

class ComicList: Codable {
    
    var argName: String?
    var argType: Int?
    var argValue: Int?
    var canedit: Int?
    var comicType: Int?
    var comics: [Comic]?
    var descriptionField: String?
    var itemTitle: String?
    var newTitleIconUrl: String?
    var sortId: String?
    var titleIconUrl: String?
}

class Comic: Codable {
    
    var authorName: String?
    var comicId: Int?
    var cornerInfo: String?
    var cover: String?
    var descriptionField: String?
    var isVip: Int?
    var name: String?
    var shortDescription: String?
    var subTitle: String?
    var tags: [String]?
}
