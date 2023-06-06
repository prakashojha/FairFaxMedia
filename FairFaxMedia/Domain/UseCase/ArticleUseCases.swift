//
//  ArticleUseCases.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/// Use Cases provided by Domain Layer
/// Use cases are executed by Presentation layer
class ArticleUseCases: ArticleUseCaseInteractor{
    
    let articleDataService: ArticleDataRepo
    
    public init(articleDataService: ArticleDataRepo){
        self.articleDataService = articleDataService
    }
    
    ///  Use case to get article data asynchronously from Data Layer
    /// - Returns:ResultType. `.success([ArticleEntity])`, .`failure(Error)`
    func executeUseCaseGetArticleData() async -> Result<[ArticleEntity], Error>{
        let result: Result<[ArticleEntity], Error>  = await articleDataService.getArticleData()
        switch(result){
        case .success(let articleEntities):
            return .success(articleEntities)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    /// Use case to get image asynchronously from Data Layer
    /// - Parameter url: url to fetch image from
    /// - Returns: ResultType. `.success([Data?])`, .`failure(Error)`
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
