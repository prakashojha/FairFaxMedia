//
//  ArticleCellModel.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/// A model for `ArticleCollectionViewCell`
/// This model contains data required by a collection view cell to display
/// This model is populated by `ArticleViewModel` and passed down to `ArticleCollectionViewCell`
struct ArticleCellModel{
    var articleURL: String?
    var headline: String?
    var abstract: String?
    var author: String?
    var imageUrl: String?
    var timeStamp: Int?
    var localPublishTime: String?
    
}
