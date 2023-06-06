//
//  ArticleDI.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class ArticleDI{
    
    let environment: AppEnvironment
    
    init(environment: AppEnvironment){
        self.environment = environment
    }
    
    ///  Manage Dependencies required by ArticleViewController
    /// - Returns: A View Model for ArticleViewController
    func dependencies()->ArticleViewModel {
        let remoteNetworkService: RemoteNetworkServiceRepo = RemoteNetworkService(urlString: environment.baseURL)
        let articleDataService: ArticleDataRepo = ArticleDataService(remoteNetworkService: remoteNetworkService)
        let articleUseCaseInteractor: ArticleUseCaseInteractor = ArticleUseCases(articleDataService: articleDataService)
        return ArticleViewModel(model: ArticleModel(), useCaseInteractor: articleUseCaseInteractor)
    }

    
    
}
