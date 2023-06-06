//
//  ArticleDataService.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleDataService: ArticleDataRepo{
    
    /// Network Service used by DataLayer
    var remoteNetworkService: RemoteNetworkServiceRepo
    
    init(remoteNetworkService: RemoteNetworkServiceRepo){
        self.remoteNetworkService = remoteNetworkService
    }
    
    
    /// Fetch data asynchronously over the network
    /// - Returns: Result Type. OnSuccess returns `[ArticleEntity]`.On Failure returns` Error`
    func getArticleData() async -> Result<[ArticleEntity], Error>{
        var articleEntities: [ArticleEntity] = []
        let result: Result<ArticleDataModel, Error> = await remoteNetworkService.requestRemoteData()
        switch(result){
        case .success(let articleData):
            if let assets = articleData.assets{
                for asset in assets{
                    articleEntities.append(asset.articleEntityDTO())
                }
            }
            return .success(articleEntities)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Fetch image asynchronously over the network.
    /// - Parameter url: url to fetch image from
    /// - Returns: ResultType. OnSuccess return `Data?` . OnFailure returns `Error`
    func getArticleImage(from url: String) async -> Result<Data?, Error>{
        let result: Result<Data?, Error> = await self.remoteNetworkService.fetchImage(from: url)
        switch(result){
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}


