//
//  ArticleDataService.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleDataService{
    
    var remoteNetworkService: RemoteNetworkServiceRepo
    
    init(remoteNetworkService: RemoteNetworkServiceRepo){
        self.remoteNetworkService = remoteNetworkService
    }
    
    
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


