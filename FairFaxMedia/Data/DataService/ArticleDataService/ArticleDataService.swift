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
    
    
    func getArticleData() async throws{
        do{
            let result: Result<ArticleDataModel, Error> = try await remoteNetworkService.requestRemoteData()
            switch(result){
            case .success(let articleData):
                await MainActor.run {
                    print((articleData.assets?[0].relatedImages?[0].url ?? "Something went wrong"))
                }
               
            case .failure(let error):
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func getImagesForArticle(id: Int){
        
    }
    
}
