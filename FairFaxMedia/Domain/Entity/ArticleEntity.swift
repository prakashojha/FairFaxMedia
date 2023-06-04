//
//  ArticleEntity.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

struct ArticleImage{
    var url: String?
    var width: Int?
    var height: Int?
    var type: String?
    
    init(url: String? = nil, width: Int? = nil, height: Int? = nil, type: String? = nil) {
        self.url = url
        self.width = width
        self.height = height
        self.type = type
    }
}

struct ArticleEntity{
    var articleURL: String?
    var headline: String?
    var abstract: String?
    var author: String?
    var articleImages: [ArticleImage]?
    var timeStamp: Int?
    
    
}
