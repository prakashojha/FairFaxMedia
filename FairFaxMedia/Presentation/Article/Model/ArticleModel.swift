//
//  ArticleModel.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/// Model used by view model to store data
struct ArticleModel{
    var articles: [ArticleEntity] = []
    var articleCellModels: [ArticleCellModel] = []
}
