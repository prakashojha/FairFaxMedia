//
//  AppDI.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

class AppDI: AppDIRepo{
    
    let environment: AppEnvironment
    
    init(environment: AppEnvironment){
        self.environment = environment
    }
    
    static let shared = AppDI(environment: AppEnvironment())
    
    func articleViewDependencies() -> ArticleViewModel {
        let articleDI: ArticleDI = ArticleDI(environment: environment)
        return articleDI.dependencies()
    }
    
    
}
