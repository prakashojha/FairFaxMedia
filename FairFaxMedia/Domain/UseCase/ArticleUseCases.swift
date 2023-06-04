//
//  ArticleUseCases.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleUseCases{
    
    let articleDataService: ArticleDataRepo
    
    public init(articleDataService: ArticleDataRepo){
        self.articleDataService = articleDataService
    }
    
    func executeUseCaseGetArticleData() async -> Result<[ArticleEntity], Error>{
        let result: Result<[ArticleEntity], Error>  = await articleDataService.getArticleData()
        switch(result){
        case .success(let articleEntities):
            return .success(articleEntities)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func executeUseCaseGetArticleImage(from url: String) async -> Result<Data?, Error>{
        let result: Result<Data?, Error> = await articleDataService.getArticleImage(from: url)
        switch(result){
        case .success(let imageData):
            return .success(imageData)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
