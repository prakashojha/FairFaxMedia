//
//  ArticleDataRepo.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/// This repo is exposed by Domain Layer
/// Any data layer meaning to provide data to Domain layer must adopt and confirm to this protocol
protocol ArticleDataRepo{
    
    /// Get data asynchronously over the network
    /// - Returns: ResultType. `.success([ArticleEntity])`, .`failure(Error)`
    func getArticleData() async -> Result<[ArticleEntity], Error>
    
    
    /// Get Image asynchronously over the network
    /// - Parameter url: url to fetch image from
    /// - Returns: ResultType. `.success([Data?])`, .`failure(Error)`
    func getArticleImage(from url: String) async -> Result<Data?, Error>
    
}
