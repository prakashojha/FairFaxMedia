//
//  ArticleEntity.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/*
    A model provide to Data Layer
    Domain layer expects data to be object of this model
 */


/// Images associated with every article
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

/// Detail of every article
struct ArticleEntity{
    var articleURL: String?
    var headline: String?
    var abstract: String?
    var author: String?
    var articleImages: [ArticleImage]?
    var timeStamp: Int?
    
    
}
