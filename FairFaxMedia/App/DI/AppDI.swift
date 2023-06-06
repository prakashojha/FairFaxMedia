//
//  AppDI.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

/// Stores all app related dependencies
/// Confirm `AppDI` protocol to provide data to Presentation layer
class AppDI: AppDIRepo{
    
    let environment: AppEnvironment
    
    init(environment: AppEnvironment){
        self.environment = environment
    }
    
    static let shared = AppDI(environment: AppEnvironment())
    
    
    /// Set Dependencies for ArticleViewModel
    /// - Returns: ArticleViewModel
    func articleViewDependencies() -> ArticleViewModel {
        let articleDI: ArticleDI = ArticleDI(environment: environment)
        return articleDI.dependencies()
    }
    
    
}
