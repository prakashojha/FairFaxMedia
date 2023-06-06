//
//  ArticleUseCaseInteractor.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/// This protocol is adopted and confirmed by Data layer to provide data to Presentation Layer
/// ViewModel from Presentation layer uses interactor to interact with use cases in Domain layer
protocol ArticleUseCaseInteractor{
    
    /// Get  articles synchronously over the network
    /// - Returns:ResultType. `.success([ArticleEntity])`, .`failure(Error)`
    func executeUseCaseGetArticleData() async -> Result<[ArticleEntity], Error>
    
    /// Get Image asynchronously over the network
    /// - Parameter url: url to fetch image from
    /// - Returns: ResultType. `.success([Data?])`, .`failure(Error)`
    func executeUseCaseGetArticleImage(from url: String) async -> Result<Data?, Error>
}
