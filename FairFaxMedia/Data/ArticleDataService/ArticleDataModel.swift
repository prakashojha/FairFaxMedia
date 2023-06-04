//
//  ArticleDataModel.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

struct RelatedImage: Decodable{
    var url: String?
    var width: Int?
    var height: Int?
    var type: String?
}

struct Asset: Decodable{
    var headline: String?
    var abstract: String?
    var author: String?
    var relatedImages: [RelatedImage]?
    var timeStamp: Int?
    
    enum CodingKeys: String, CodingKey{
        case headline = "headline"
        case abstract = "theAbstract"
        case author = "byLine"
        case relatedImages = "relatedImages"
        case timeStamp = "timeStamp"
    }
    
    func articleEntityDTO()->ArticleEntity{
        return ArticleEntity(
            headline: self.headline,
            abstract: self.abstract,
            author: self.author,
            articleImages: self.relatedImages.map { $0.map{image in
                return ArticleImage.init(url: image.url, width: image.width, height: image.height, type: image.type)}
            },
            timeStamp: self.timeStamp )
    }
}

struct ArticleDataModel: Decodable{
    var assets: [Asset]?
    
    enum CodingKeys: String, CodingKey{
        case assets = "assets"
    }
}
