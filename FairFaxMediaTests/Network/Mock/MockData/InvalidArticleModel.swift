//
//  InvalidArticleModel.swift
//  FairFaxMediaTests
//
//  Created by bindu.ojha on 5/06/23.
//

import Foundation


struct RelatedImage: Decodable{
    var url: String?
    var width: Int?
    var height: Int?
    var type: String?
}

struct Asset: Decodable{
    var articleURL: String?
    var headline: String?
    var abstract: String?
    var author: String?
    var relatedImages: [RelatedImage]?
    var timeStamp: String?
    
    enum CodingKeys: String, CodingKey{
        case articleURL = "url"
        case headline = "headline"
        case abstract = "theAbstract"
        case author = "byLine"
        case relatedImages = "relatedImages"
        case timeStamp = "timeStamp"
    }
}

struct InvalidArticleModel: Decodable{
    var assets: [Asset]?
    
    enum CodingKeys: String, CodingKey{
        case assets = "assets"
    }
}
